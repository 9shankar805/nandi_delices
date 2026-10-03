import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../models/customer_order.dart';
import '../models/restaurant_config.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  OrderType _orderType = OrderType.pickup;
  String? _customerName;
  String? _customerPhone;
  String? _deliveryAddress;
  double? _latitude;
  double? _longitude;
  String? _orderNote;
  String? _preferredTime;

  Map<String, CartItem> get items => _items;
  List<CartItem> get itemList => _items.values.toList();
  OrderType get orderType => _orderType;
  String? get customerName => _customerName;
  String? get customerPhone => _customerPhone;
  String? get deliveryAddress => _deliveryAddress;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get orderNote => _orderNote;
  String? get preferredTime => _preferredTime;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get totalItemCount {
    int count = 0;
    for (final item in _items.values) {
      count += item.quantity;
    }
    return count;
  }

  double get subtotal {
    double sum = 0.0;
    for (final item in _items.values) {
      sum += item.totalPrice;
    }
    return sum;
  }

  double calculateDeliveryFee(RestaurantConfig config) {
    if (_orderType == OrderType.delivery) {
      return config.deliveryFee;
    }
    return 0.0;
  }

  double calculateGrandTotal(RestaurantConfig config) {
    return subtotal + calculateDeliveryFee(config);
  }

  int getItemQuantity(String itemId) {
    return _items[itemId]?.quantity ?? 0;
  }

  void addItem(MenuItem item, {int quantity = 1, String? note}) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity += quantity;
      if (note != null && note.isNotEmpty) {
        _items[item.id]!.customerNote = note;
      }
    } else {
      _items[item.id] = CartItem(
        item: item,
        quantity: quantity,
        customerNote: note,
      );
    }
    notifyListeners();
  }

  void incrementQuantity(String itemId) {
    if (_items.containsKey(itemId)) {
      _items[itemId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    if (_items.containsKey(itemId)) {
      if (_items[itemId]!.quantity > 1) {
        _items[itemId]!.quantity -= 1;
      } else {
        _items.remove(itemId);
      }
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  void updateItemNote(String itemId, String? note) {
    if (_items.containsKey(itemId)) {
      _items[itemId]!.customerNote = note;
      notifyListeners();
    }
  }

  void setOrderType(OrderType type) {
    _orderType = type;
    notifyListeners();
  }

  void setCustomerInfo({
    String? name,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    String? note,
    String? preferredTime,
  }) {
    if (name != null) _customerName = name;
    if (phone != null) _customerPhone = phone;
    if (address != null) _deliveryAddress = address;
    if (latitude != null) _latitude = latitude;
    if (longitude != null) _longitude = longitude;
    if (note != null) _orderNote = note;
    if (preferredTime != null) _preferredTime = preferredTime;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  CustomerOrder createOrder(RestaurantConfig config) {
    final fee = calculateDeliveryFee(config);
    final total = subtotal + fee;

    return CustomerOrder(
      orderReference: CustomerOrder.generateReference(),
      customerName: _customerName ?? '',
      phone: _customerPhone ?? '',
      orderType: _orderType,
      address: _orderType == OrderType.delivery ? _deliveryAddress : null,
      latitude: _orderType == OrderType.delivery ? _latitude : null,
      longitude: _orderType == OrderType.delivery ? _longitude : null,
      note: _orderNote,
      preferredTime: _preferredTime,
      items: itemList,
      subtotal: subtotal,
      deliveryFee: fee,
      total: total,
      createdAt: DateTime.now(),
    );
  }
}
