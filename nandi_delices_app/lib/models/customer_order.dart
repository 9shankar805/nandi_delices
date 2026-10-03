import 'package:intl/intl.dart';
import 'cart_item.dart';
import 'restaurant_config.dart';

enum OrderType {
  delivery,
  pickup,
}

class CustomerOrder {
  final String orderReference;
  final String customerName;
  final String phone;
  final OrderType orderType;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? note;
  final String? preferredTime;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;

  CustomerOrder({
    required this.orderReference,
    required this.customerName,
    required this.phone,
    required this.orderType,
    this.address,
    this.latitude,
    this.longitude,
    this.note,
    this.preferredTime,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
  });

  static String generateReference() {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyyMMdd').format(now);
    final randomDigits = (now.millisecondsSinceEpoch % 900 + 100).toString();
    return 'ND-$dateStr-$randomDigits';
  }

  /// Builds WhatsApp pre-filled text matching WORKFLOW.md exactly
  String buildWhatsAppMessage(RestaurantConfig config) {
    final buffer = StringBuffer();
    final isDelivery = orderType == OrderType.delivery;
    final orderTypeLabel = isDelivery ? "Livraison / Delivery" : "À emporter / Pickup";

    buffer.writeln("🍽️ *${config.name.toUpperCase()}*");
    buffer.writeln(config.tagline.toUpperCase());
    buffer.writeln();
    buffer.writeln("📋 *Commande / Order:* $orderReference");
    buffer.writeln();
    buffer.writeln("👤 *Client / Customer:* ${customerName.trim()}");
    buffer.writeln("📞 *Téléphone / Phone:* ${phone.trim()}");
    buffer.writeln("🚚 *Type:* $orderTypeLabel");

    if (isDelivery && address != null && address!.trim().isNotEmpty) {
      buffer.writeln("📍 *Adresse / Address:* ${address!.trim()}");
      if (latitude != null && longitude != null) {
        buffer.writeln("🗺️ *Itinéraire GPS:* https://maps.google.com/?q=$latitude,$longitude");
      }
    }

    if (preferredTime != null && preferredTime!.trim().isNotEmpty) {
      buffer.writeln("⏰ *Heure souhaitée / Preferred Time:* ${preferredTime!.trim()}");
    }

    buffer.writeln();
    buffer.writeln("🛒 *ARTICLES / ITEMS:*");

    for (final cartItem in items) {
      final item = cartItem.item;
      final qty = cartItem.quantity;
      if (item.isSurCommande) {
        buffer.writeln("• $qty × ${item.nameFr} (${item.nameEn}) — *Sur commande*");
      } else {
        final linePrice = (item.price ?? 0.0) * qty;
        buffer.writeln("• $qty × ${item.nameFr} (${item.nameEn}) — *${config.currencySymbol}${linePrice.toStringAsFixed(2)}*");
      }
      if (cartItem.customerNote != null && cartItem.customerNote!.trim().isNotEmpty) {
        buffer.writeln("   _(Note: ${cartItem.customerNote!.trim()})_");
      }
    }

    buffer.writeln();
    buffer.writeln("─────────────────────────");
    buffer.writeln("Sous-total / Subtotal: *${config.currencySymbol}${subtotal.toStringAsFixed(2)}*");

    if (isDelivery && deliveryFee > 0) {
      buffer.writeln("Livraison / Delivery: *${config.currencySymbol}${deliveryFee.toStringAsFixed(2)}*");
    } else if (isDelivery) {
      buffer.writeln("Livraison / Delivery: *Gratuit / Free*");
    }

    buffer.writeln("*TOTAL:* *${config.currencySymbol}${total.toStringAsFixed(2)}*");
    buffer.writeln("─────────────────────────");

    if (note != null && note!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln("💬 *Note spéciale / Special Instructions:*");
      buffer.writeln(note!.trim());
    }

    buffer.writeln();
    buffer.writeln("Merci pour votre commande ! 🙏 / Thank you!");

    return buffer.toString();
  }

  /// Builds the direct WhatsApp URL
  String buildWhatsAppUrl(RestaurantConfig config) {
    final cleanNumber = config.whatsappNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final message = buildWhatsAppMessage(config);
    final encodedMessage = Uri.encodeComponent(message);
    return "https://wa.me/$cleanNumber?text=$encodedMessage";
  }
}
