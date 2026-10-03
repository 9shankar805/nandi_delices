import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/language_toggle_button.dart';
import 'settings_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String number, String message) async {
    final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showReferenceMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/reference_menu.jpeg',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: const Text("Original Printed Menu Reference"),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(lang.isFrench ? "À Propos & Contact" : "About & Contact"),
        actions: [
          const LanguageToggleButton(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: lang.isFrench ? "Paramètres" : "Settings",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Storefront Banner with Circular Logo
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      'assets/images/store_image.webp',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: AppTheme.creamDark,
                        child: const Icon(Icons.storefront, size: 64, color: AppTheme.primaryGreen),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: AppTheme.softShadow,
                      border: Border.all(color: AppTheme.gold, width: 3),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.restaurant, size: 36, color: AppTheme.primaryGreen),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 46),

            Text(
              restaurant.name,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppTheme.black),
            ),

            const SizedBox(height: 4),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.gold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                restaurant.tagline.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppTheme.black),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              restaurant.subtitle,
              style: const TextStyle(color: AppTheme.mutedText, fontSize: 13, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 24),

            // Quick Contact Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openWhatsApp(
                      restaurant.whatsappNumber,
                      lang.isFrench
                          ? "Bonjour Nandi Delices, j'aimerais avoir un renseignement !"
                          : "Hello Nandi Delices, I would like to ask a question!",
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                    label: const Text("WhatsApp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.whatsappGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(restaurant.phone),
                    icon: const Icon(Icons.phone_outlined, color: Colors.white, size: 18),
                    label: Text(
                      lang.isFrench ? "Appeler" : "Call",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Restaurant Information Cards
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  // Opening Hours
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.access_time, color: AppTheme.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.isFrench ? "Horaires d'ouverture" : "Opening Hours",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant.openingHours,
                              style: const TextStyle(color: AppTheme.mutedText, fontSize: 13, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: AppTheme.border),
                  ),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.warmRed.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: AppTheme.warmRed, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.isFrench ? "Adresse du restaurant" : "Restaurant Address",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant.address,
                              style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: AppTheme.border),
                  ),

                  // WhatsApp Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.whatsappGreen.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat, color: AppTheme.whatsappGreen, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.isFrench ? "Numéro WhatsApp commandes" : "WhatsApp Orders Number",
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "+${restaurant.whatsappNumber}",
                              style: const TextStyle(color: AppTheme.black, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Reference Menu Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: AppTheme.primaryGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        lang.isFrench ? "Carte Originale du Restaurant" : "Original Restaurant Menu",
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lang.isFrench
                        ? "Consultez la version imprimée originale de notre carte traiteur."
                        : "View the official printed menu reference.",
                    style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => _showReferenceMenuDialog(context),
                    icon: const Icon(Icons.zoom_in, color: AppTheme.black),
                    label: Text(
                      lang.isFrench ? "Agrandir le Menu Imprimé" : "Open Original Menu Image",
                      style: const TextStyle(color: AppTheme.black, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
