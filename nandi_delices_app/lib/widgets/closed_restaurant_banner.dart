import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';

class ClosedRestaurantBanner extends StatelessWidget {
  const ClosedRestaurantBanner({super.key});

  Future<void> _openWhatsAppInquiry(String number, String message) async {
    final clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();

    if (restaurant.isOpen) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warmRed.withAlpha(20),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Closed Image Header
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(19),
              topRight: Radius.circular(19),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: Image.asset(
                'assets/images/closed.webp',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: const Color(0xFFFFEBEE),
                  child: const Center(
                    child: Icon(Icons.access_time_filled, color: AppTheme.warmRed, size: 40),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.warmRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lang.isFrench ? "ACTUELLEMENT FERMÉ" : "CURRENTLY CLOSED",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      lang.isFrench ? "Pré-commandes ouvertes" : "Pre-orders open",
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lang.isFrench
                      ? "Le restaurant est actuellement fermé. Vous pouvez toujours composer votre panier et envoyer votre commande sur WhatsApp pour la prochaine ouverture !"
                      : "The restaurant is currently closed. You can still prepare your cart and send your WhatsApp order for our next opening!",
                  style: const TextStyle(fontSize: 12, color: AppTheme.mutedText, height: 1.35),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppTheme.primaryGreen),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          restaurant.openingHours,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openWhatsAppInquiry(
                      restaurant.whatsappNumber,
                      lang.isFrench
                          ? "Bonjour Nandi Delices, je souhaite savoir à quelle heure vous ouvrez aujourd'hui !"
                          : "Hello Nandi Delices, I would like to know what time you open today!",
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.whatsappGreen),
                    label: Text(
                      lang.isFrench ? "Poser une question sur WhatsApp" : "Ask a question on WhatsApp",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
