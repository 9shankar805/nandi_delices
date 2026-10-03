import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;
  String? customerNote;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.customerNote,
  });

  double get unitPrice => item.price ?? 0.0;
  double get totalPrice => unitPrice * quantity;

  String formattedTotal([String symbol = '€']) {
    if (item.isSurCommande) {
      return 'Sur devis';
    }
    return '$symbol${totalPrice.toStringAsFixed(2)}';
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': item.id,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'customerNote': customerNote,
    };
  }
}
