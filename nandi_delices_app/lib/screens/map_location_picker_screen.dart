import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../config/app_theme.dart';
import '../services/location_service.dart';

class MapLocationPickerScreen extends StatefulWidget {
  final LatLng? initialPosition;

  const MapLocationPickerScreen({super.key, this.initialPosition});

  @override
  State<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  late final MapController _mapController;
  late LatLng _currentCenter;
  String _addressPreview = "Recherche de l'adresse...";
  bool _isGeocoding = false;
  bool _isLocating = false;
  Timer? _debounceTimer;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Default to Paris (or Mauritius or passed location)
    _currentCenter = widget.initialPosition ?? const LatLng(48.8566, 2.3522);
    _reverseGeocodeCenter();
    _tryAutoDetectLocation();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _tryAutoDetectLocation() async {
    if (widget.initialPosition == null) {
      await _moveToCurrentLocation();
    }
  }

  Future<void> _moveToCurrentLocation() async {
    setState(() => _isLocating = true);
    final pos = await LocationService.getCurrentPosition();
    if (pos != null && mounted) {
      final point = LatLng(pos.latitude, pos.longitude);
      _mapController.move(point, 16);
      setState(() {
        _currentCenter = point;
        _isLocating = false;
      });
      _reverseGeocodeCenter();
    } else {
      if (mounted) {
        setState(() => _isLocating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Impossible de détecter la position GPS. Vous pouvez vous déplacer sur la carte."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    _currentCenter = camera.center;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _reverseGeocodeCenter();
    });
  }

  Future<void> _reverseGeocodeCenter() async {
    if (!mounted) return;
    setState(() => _isGeocoding = true);
    final result = await LocationService.reverseGeocode(_currentCenter);
    if (mounted) {
      setState(() {
        _addressPreview = result.formattedAddress;
        _isGeocoding = false;
      });
    }
  }

  Future<void> _searchPlace(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await LocationService.searchPlaces(query);
    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  void _selectSearchResult(Map<String, dynamic> place) {
    final lat = double.tryParse(place['lat'].toString());
    final lon = double.tryParse(place['lon'].toString());
    if (lat != null && lon != null) {
      final point = LatLng(lat, lon);
      _mapController.move(point, 16);
      setState(() {
        _currentCenter = point;
        _searchResults = [];
        _searchController.text = place['display_name'] ?? '';
      });
      _reverseGeocodeCenter();
      FocusScope.of(context).unfocus();
    }
  }

  void _confirmSelection() {
    final result = LocationResult(
      point: _currentCenter,
      formattedAddress: _addressPreview,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FlutterMap OpenStreetMap Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15.0,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.nandidelices.app',
                maxZoom: 19,
              ),
            ],
          ),

          // Static Center Pin Marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.black.withAlpha(220),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isGeocoding ? "Localisation..." : "Livrer ici 📍",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.location_on,
                    size: 46,
                    color: AppTheme.warmRed,
                    shadows: [
                      Shadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  Container(
                    width: 10,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top App Bar & Search Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Back Button
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Search input
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (q) => _searchPlace(q),
                            decoration: InputDecoration(
                              hintText: "Rechercher une adresse / rue...",
                              prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText, size: 20),
                              suffixIcon: _isSearching
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                                      ),
                                    )
                                  : _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.close, size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() => _searchResults = []);
                                          },
                                        )
                                      : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Search Auto-complete Suggestions Dropdown
                  if (_searchResults.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        separatorBuilder: (c, i) => const Divider(height: 1, color: AppTheme.border),
                        itemBuilder: (context, index) {
                          final place = _searchResults[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.location_on_outlined, color: AppTheme.primaryGreen, size: 20),
                            title: Text(
                              place['display_name'] ?? '',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _selectSearchResult(place),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Floating GPS My Location Button
          Positioned(
            right: 16,
            bottom: 190,
            child: FloatingActionButton(
              heroTag: 'gps_button',
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryGreen,
              elevation: 4,
              onPressed: _moveToCurrentLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          // Bottom Confirmation Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: AppTheme.softShadow,
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_pin, color: AppTheme.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Adresse de livraison sélectionnée",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                      if (_isGeocoding)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _addressPreview,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.black,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _confirmSelection,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    label: const Text(
                      "Confirmer cet emplacement",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
