import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/customer_order.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';
import '../services/location_service.dart';
import '../widgets/language_toggle_button.dart';
import 'map_location_picker_screen.dart';
import 'whatsapp_handoff_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _timeController;
  late TextEditingController _noteController;

  double? _selectedLat;
  double? _selectedLng;
  bool _isDetectingLocation = false;

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartProvider>();
    _nameController = TextEditingController(text: cart.customerName ?? '');
    _phoneController = TextEditingController(text: cart.customerPhone ?? '');
    _addressController = TextEditingController(text: cart.deliveryAddress ?? '');
    _timeController = TextEditingController(text: cart.preferredTime ?? '');
    _noteController = TextEditingController(text: cart.orderNote ?? '');
    _selectedLat = cart.latitude;
    _selectedLng = cart.longitude;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _timeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Live GPS Location Detection
  Future<void> _fetchLiveGPSLocation() async {
    setState(() => _isDetectingLocation = true);

    try {
      final pos = await LocationService.getCurrentPosition();
      if (pos != null && mounted) {
        final point = LatLng(pos.latitude, pos.longitude);
        final result = await LocationService.reverseGeocode(point);

        setState(() {
          _selectedLat = pos.latitude;
          _selectedLng = pos.longitude;
          _addressController.text = result.formattedAddress;
        });

        if (mounted) {
          final isFr = context.read<LanguageProvider>().isFrench;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isFr
                  ? "📍 Position détectée : ${result.formattedAddress}"
                  : "📍 Location detected: ${result.formattedAddress}"),
              backgroundColor: AppTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else if (mounted) {
        final isFr = context.read<LanguageProvider>().isFrench;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFr
                ? "Impossible d'obtenir la position GPS. Vérifiez les autorisations."
                : "Unable to obtain GPS location. Please check location permissions."),
            backgroundColor: AppTheme.warmRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: AppTheme.warmRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDetectingLocation = false);
      }
    }
  }

  /// Interactive Map Location Picker
  Future<void> _openMapPicker() async {
    LatLng? initial;
    if (_selectedLat != null && _selectedLng != null) {
      initial = LatLng(_selectedLat!, _selectedLng!);
    }

    final LocationResult? result = await Navigator.push<LocationResult>(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPickerScreen(initialPosition: initial),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLat = result.point.latitude;
        _selectedLng = result.point.longitude;
        _addressController.text = result.formattedAddress;
      });

      final isFr = context.read<LanguageProvider>().isFrench;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFr
              ? "🗺️ Emplacement défini : ${result.formattedAddress}"
              : "🗺️ Location set: ${result.formattedAddress}"),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _submitOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cart = context.read<CartProvider>();
    final restaurant = context.read<RestaurantProvider>().config;

    cart.setCustomerInfo(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      latitude: _selectedLat,
      longitude: _selectedLng,
      preferredTime: _timeController.text.trim(),
      note: _noteController.text.trim(),
    );

    final order = cart.createOrder(restaurant);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WhatsAppHandoffDialog(
        order: order,
        config: restaurant,
        onOrderCompleted: () {
          cart.clearCart();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();
    final isDelivery = cart.orderType == OrderType.delivery;
    final deliveryFee = cart.calculateDeliveryFee(restaurant);
    final grandTotal = cart.calculateGrandTotal(restaurant);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(lang.isFrench ? "Caisse / Checkout" : "Checkout"),
        actions: const [
          LanguageToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Type Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.creamDark,
                        border: Border.all(
                          color: isDelivery ? AppTheme.primaryGreen : AppTheme.gold,
                          width: 1.5,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        isDelivery ? 'assets/images/delivery_moto.webp' : 'assets/images/store_image.webp',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Icon(
                          isDelivery ? Icons.delivery_dining : Icons.storefront,
                          color: isDelivery ? AppTheme.primaryGreen : AppTheme.goldDark,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDelivery
                                ? (lang.isFrench ? "Livraison à domicile" : "Home Delivery")
                                : (lang.isFrench ? "Retrait au restaurant" : "Restaurant Takeaway / Pickup"),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          Text(
                            isDelivery
                                ? "${lang.isFrench ? 'Frais de livraison' : 'Delivery fee'} : ${restaurant.currencySymbol}${deliveryFee.toStringAsFixed(2)}"
                                : (lang.isFrench
                                    ? "Gratuit • Retrait direct chez Nandi Delices"
                                    : "Free • Direct takeaway at Nandi Delices"),
                            style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Customer Information
              Text(
                lang.isFrench ? "1. Vos Coordonnées" : "1. Contact Details",
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: lang.isFrench ? "Nom complet *" : "Full Name *",
                        hintText: "Ex: Marie Dupont",
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return lang.isFrench ? "Veuillez entrer votre nom" : "Please enter your name";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: lang.isFrench ? "Numéro de téléphone *" : "Phone Number *",
                        hintText: "Ex: +33 6 12 34 56 78",
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return lang.isFrench
                              ? "Veuillez entrer votre numéro de téléphone"
                              : "Please enter your phone number";
                        }
                        if (value.trim().length < 6) {
                          return lang.isFrench
                              ? "Numéro de téléphone incomplet"
                              : "Invalid phone number";
                        }
                        return null;
                      },
                    ),

                    // Delivery Address & Location Section
                    if (isDelivery) ...[
                      const SizedBox(height: 16),
                      const Divider(color: AppTheme.border),
                      const SizedBox(height: 10),

                      // Location Action Buttons (Live GPS & Map Picker)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isDetectingLocation ? null : _fetchLiveGPSLocation,
                              icon: _isDetectingLocation
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                                    )
                                  : const Icon(Icons.my_location, size: 16, color: AppTheme.primaryGreen),
                              label: Text(
                                _isDetectingLocation
                                    ? (lang.isFrench ? "Détection..." : "Locating...")
                                    : (lang.isFrench ? "Position GPS" : "Live GPS"),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                side: const BorderSide(color: AppTheme.primaryGreen, width: 1.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _openMapPicker,
                              icon: const Icon(Icons.map_outlined, size: 16, color: Colors.white),
                              label: Text(
                                lang.isFrench ? "Choisir sur Carte" : "Pick on Map",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_selectedLat != null && _selectedLng != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFC8E6C9)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 14),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "${lang.isFrench ? 'GPS vérifié' : 'GPS verified'}: ${_selectedLat!.toStringAsFixed(4)}, ${_selectedLng!.toStringAsFixed(4)}",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Full Delivery Address Input
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: lang.isFrench ? "Adresse de livraison complète *" : "Full Delivery Address *",
                          hintText: lang.isFrench
                              ? "Rue, Bâtiment, Étage, Digicode, Ville..."
                              : "Street, Building, Floor, Door code, City...",
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        validator: (value) {
                          if (isDelivery && (value == null || value.trim().isEmpty)) {
                            return lang.isFrench
                                ? "Veuillez préciser votre adresse de livraison"
                                : "Please enter your delivery address";
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Preferred Time (Optional)
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: lang.isFrench
                            ? "Heure souhaitée (Optionnel)"
                            : "Preferred Time (Optional)",
                        hintText: lang.isFrench ? "Ex: Dès que possible ou 19h45" : "e.g. As soon as possible / 7:45 PM",
                        prefixIcon: const Icon(Icons.access_time_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Order Notes
              Text(
                lang.isFrench ? "2. Instructions Particulières" : "2. Special Instructions",
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: lang.isFrench ? "Remarques pour la cuisine / notes" : "Kitchen notes & allergies",
                    hintText: lang.isFrench
                        ? "Ex: Piment doux, allergies, sonner à l'interphone..."
                        : "e.g. Mild spice, no coriander, ring door bell...",
                    prefixIcon: const Icon(Icons.comment_outlined),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Section: Order Summary
              Text(
                lang.isFrench ? "3. Récapitulatif" : "3. Order Summary",
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  children: [
                    ...cart.itemList.map((cartItem) {
                      final item = cartItem.item;
                      final itemName = lang.isFrench ? item.nameFr : item.nameEn;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              "${cartItem.quantity} ×",
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                itemName,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item.isSurCommande
                                  ? (lang.isFrench ? "Sur devis" : "Quote")
                                  : cartItem.formattedTotal(restaurant.currencySymbol),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: AppTheme.border),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lang.isFrench ? "Sous-total" : "Subtotal", style: const TextStyle(color: AppTheme.mutedText)),
                        Text("${restaurant.currencySymbol}${cart.subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDelivery
                              ? (lang.isFrench ? "Livraison" : "Delivery")
                              : (lang.isFrench ? "Retrait" : "Pickup"),
                          style: const TextStyle(color: AppTheme.mutedText),
                        ),
                        Text(
                          deliveryFee > 0
                              ? "${restaurant.currencySymbol}${deliveryFee.toStringAsFixed(2)}"
                              : (lang.isFrench ? "Gratuit" : "Free"),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: deliveryFee > 0 ? AppTheme.black : AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: AppTheme.border),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.isFrench ? "TOTAL À RÉGLER" : "TOTAL",
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        Text(
                          "${restaurant.currencySymbol}${grandTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // WhatsApp CTA Button
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.chat_bubble, color: Colors.white, size: 22),
                label: Text(
                  lang.isFrench ? "Commander sur WhatsApp" : "Place Order on WhatsApp",
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.whatsappGreen,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: const Color(0x6625D366),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  lang.isFrench
                      ? "🔒 Redirection directe et sécurisée vers WhatsApp"
                      : "🔒 Direct and secure handoff to WhatsApp",
                  style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
