import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_theme.dart';
import '../models/customer_order.dart';
import '../models/restaurant_config.dart';
import '../providers/language_provider.dart';

class WhatsAppHandoffDialog extends StatefulWidget {
  final CustomerOrder order;
  final RestaurantConfig config;
  final VoidCallback onOrderCompleted;

  const WhatsAppHandoffDialog({
    super.key,
    required this.order,
    required this.config,
    required this.onOrderCompleted,
  });

  @override
  State<WhatsAppHandoffDialog> createState() => _WhatsAppHandoffDialogState();
}

class _WhatsAppHandoffDialogState extends State<WhatsAppHandoffDialog> {
  bool _isLaunching = false;
  String? _errorMessage;

  Future<void> _launchWhatsApp() async {
    setState(() {
      _isLaunching = true;
      _errorMessage = null;
    });

    final urlString = widget.order.buildWhatsAppUrl(widget.config);
    final uri = Uri.parse(urlString);

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        final isFr = context.read<LanguageProvider>().isFrench;
        setState(() {
          _errorMessage = isFr
              ? "Impossible d'ouvrir WhatsApp automatiquement. Veuillez copier le texte de la commande ci-dessous."
              : "Could not open WhatsApp automatically. Please copy the order text below.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLaunching = false;
        });
      }
    }
  }

  void _copyOrderMessage() {
    final message = widget.order.buildWhatsAppMessage(widget.config);
    Clipboard.setData(ClipboardData(text: message));
    final isFr = context.read<LanguageProvider>().isFrench;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFr ? "Message de commande copié !" : "Order message copied!"),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _callRestaurant() async {
    final telUri = Uri.parse('tel:${widget.config.phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.order.buildWhatsAppMessage(widget.config);
    final lang = context.watch<LanguageProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppTheme.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with WhatsApp Icon
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.whatsappGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x5525D366),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                lang.isFrench ? "Finaliser sur WhatsApp" : "Finish on WhatsApp",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
              ),

              const SizedBox(height: 6),

              Text(
                lang.isFrench
                    ? "Votre commande est prête ! Cliquez ci-dessous pour ouvrir WhatsApp avec votre message pré-rempli. Vous devrez simplement appuyer sur « Envoyer »."
                    : "Your order is ready! Tap below to open WhatsApp with your pre-filled order message. You just need to press 'Send'.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppTheme.mutedText, height: 1.4),
              ),

              const SizedBox(height: 14),

              // Order Ref Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.creamDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.receipt_long, size: 16, color: AppTheme.primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      widget.order.orderReference,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Message Preview Box
              Container(
                constraints: const BoxConstraints(maxHeight: 160),
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FDF9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF1B5E20),
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppTheme.warmRed, fontSize: 12),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Primary Action: Open WhatsApp Button
              ElevatedButton.icon(
                onPressed: _isLaunching ? null : _launchWhatsApp,
                icon: _isLaunching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                label: Text(
                  lang.isFrench ? "Ouvrir WhatsApp et Envoyer" : "Open WhatsApp and Send",
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.whatsappGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),

              const SizedBox(height: 10),

              // Secondary Fallbacks: Copy Text & Call
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyOrderMessage,
                      icon: const Icon(Icons.copy, size: 16, color: AppTheme.black),
                      label: Text(
                        lang.isFrench ? "Copier le texte" : "Copy text",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _callRestaurant,
                      icon: const Icon(Icons.phone, size: 16, color: AppTheme.primaryGreen),
                      label: Text(
                        lang.isFrench ? "Appeler" : "Call",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  widget.onOrderCompleted();
                  Navigator.pop(context);
                },
                child: Text(
                  lang.isFrench ? "Fermer / Retour à l'accueil" : "Close / Back to Home",
                  style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
