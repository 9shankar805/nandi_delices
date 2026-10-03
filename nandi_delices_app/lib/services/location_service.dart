import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationResult {
  final LatLng point;
  final String formattedAddress;
  final String? street;
  final String? city;
  final String? postalCode;

  LocationResult({
    required this.point,
    required this.formattedAddress,
    this.street,
    this.city,
    this.postalCode,
  });

  String get mapsUrl => 'https://maps.google.com/?q=${point.latitude},${point.longitude}';
}

class LocationService {
  /// Request location permission and get current device position
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      debugPrint('Error getting position: $e');
      return await Geolocator.getLastKnownPosition();
    }
  }

  /// Reverse geocodes latitude and longitude into a readable address using OpenStreetMap Nominatim
  static Future<LocationResult> reverseGeocode(LatLng point) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'NandiDelicesApp/1.0 (contact@nandidelices.com)',
          'Accept-Language': 'fr,en',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>? ?? {};

        final road = address['road'] ?? address['pedestrian'] ?? address['street'] ?? '';
        final houseNumber = address['house_number'] ?? '';
        final suburb = address['suburb'] ?? address['neighbourhood'] ?? '';
        final city = address['city'] ?? address['town'] ?? address['village'] ?? address['municipality'] ?? '';
        final postcode = address['postcode'] ?? '';

        String streetPart = '';
        if (houseNumber.toString().isNotEmpty && road.toString().isNotEmpty) {
          streetPart = '$houseNumber $road';
        } else if (road.toString().isNotEmpty) {
          streetPart = road.toString();
        }

        final parts = <String>[];
        if (streetPart.isNotEmpty) parts.add(streetPart);
        if (suburb.toString().isNotEmpty && suburb != city) parts.add(suburb.toString());
        if (postcode.toString().isNotEmpty && city.toString().isNotEmpty) {
          parts.add('$postcode $city');
        } else if (city.toString().isNotEmpty) {
          parts.add(city.toString());
        }

        final formatted = parts.isNotEmpty
            ? parts.join(', ')
            : (data['display_name'] as String? ?? 'Emplacement sélectionné (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})');

        return LocationResult(
          point: point,
          formattedAddress: formatted,
          street: streetPart,
          city: city.toString(),
          postalCode: postcode.toString(),
        );
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }

    return LocationResult(
      point: point,
      formattedAddress: 'Position GPS (${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)})',
    );
  }

  /// Search places / addresses
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(query)}&limit=5&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'NandiDelicesApp/1.0 (contact@nandidelices.com)',
          'Accept-Language': 'fr,en',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (e) {
      debugPrint('Search place error: $e');
    }
    return [];
  }
}
