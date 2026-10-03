import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/customer_order.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/language_toggle_button.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onBrowseMenu;

  const CartScreen({super.key, required this.onBrowseMenu});

  void _showClearConfirmDialog(BuildContext context, CartProvider cart, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.isFrench ? "Vider le panier ?" : "Clear cart?"),
        content: Text(
          lang.isFrench
              ? "Êtes-vous sûr de vouloir retirer tous les articles du panier ?"
              : "Are you sure you want to remove all items from your cart?",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.isFrench ? "Annuler" : "Cancel", style: const TextStyle(color: AppTheme.mutedText)),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warmRed,
              minimumSize: const Size(100, 40),
            ),
            child: Text(lang.isFrench ? "Vider" : "Clear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();

    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.cream,
        appBar: AppBar(
          title: Text(lang.isFrench ? "Mon Panier" : "My Cart"),
          actions: const [
            LanguageToggleButton(),
            SizedBox(width: 8),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 72,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  lang.isFrench ? "Votre panier est vide" : "Your cart is empty",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lang.isFrench
                      ? "Explorez notre délicieuse carte créole et ajoutez vos plats préférés !"
                      : "Explore our delicious Mauritian menu and add your favorite dishes!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: onBrowseMenu,
                  icon: const Icon(Icons.restaurant_menu),
                  label: Text(lang.isFrench ? "Découvrir le Menu" : "Browse Menu"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final deliveryFee = cart.calculateDeliveryFee(restaurant);
    final grandTotal = cart.calculateGrandTotal(restaurant);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.isFrench ? "Mon Panier" : "My Cart"),
            Text(
              "${cart.totalItemCount} ${lang.isFrench ? 'article(s)' : 'item(s)'}",
              style: const TextStyle(fontSize: 12, color: AppTheme.mutedText, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          const LanguageToggleButton(),
          TextButton.icon(
            onPressed: () => _showClearConfirmDialog(context, cart, lang),
            icon: const Icon(Icons.delete_sweep_outlined, size: 20, color: AppTheme.warmRed),
            label: Text(
              lang.isFrench ? "Vider" : "Clear",
              style: const TextStyle(color: AppTheme.warmRed, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Cart Items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.itemList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cartItem = cart.itemList[index];
                final item = cartItem.item;
                final itemName = lang.isFrench ? item.nameFr : item.nameEn;
                final itemSecondary = lang.isFrench ? item.nameEn : item.nameFr;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.border),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: item.image != null && item.image!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: item.image!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppTheme.creamDark,
                                  child: const Icon(Icons.restaurant, color: AppTheme.primaryGreen),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppTheme.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              itemSecondary,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.mutedText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.isSurCommande
                                  ? (lang.isFrench ? "Sur commande" : "On Order")
                                  : "${item.formattedPrice(restaurant.currencySymbol)} / ${item.unit}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            if (cartItem.customerNote != null && cartItem.customerNote!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  "Note: ${cartItem.customerNote}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: AppTheme.mutedText,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Quantity Stepper
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.creamDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 14, color: AppTheme.warmRed),
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.all(2),
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  onPressed: () => cart.decrementQuantity(item.id),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    "${cartItem.quantity}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 14, color: AppTheme.primaryGreen),
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.all(2),
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  onPressed: () => cart.incrementQuantity(item.id),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.isSurCommande
                                ? (lang.isFrench ? "Sur devis" : "Quote")
                                : cartItem.formattedTotal(restaurant.currencySymbol),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: AppTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Order Type Selector
            Text(
              lang.isFrench ? "Mode de commande" : "Order Mode",
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Delivery Option (with delivery_moto.webp)
                Expanded(
                  child: GestureDetector(
                    onTap: () => cart.setOrderType(OrderType.delivery),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: cart.orderType == OrderType.delivery ? AppTheme.primaryGreen : AppTheme.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: cart.orderType == OrderType.delivery ? AppTheme.primaryGreen : AppTheme.border,
                          width: 1.5,
                        ),
                        boxShadow: cart.orderType == OrderType.delivery ? AppTheme.greenShadow : AppTheme.softShadow,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cart.orderType == OrderType.delivery
                                  ? Colors.white
                                  : AppTheme.creamDark,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/delivery_moto.webp',
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.delivery_dining, color: AppTheme.primaryGreen, size: 28),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang.isFrench ? "Livraison" : "Delivery",
                            style: TextStyle(
                              color: cart.orderType == OrderType.delivery ? Colors.white : AppTheme.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            restaurant.deliveryFee > 0
                                ? "+${restaurant.currencySymbol}${restaurant.deliveryFee.toStringAsFixed(2)}"
                                : (lang.isFrench ? "Gratuit" : "Free"),
                            style: TextStyle(
                              color: cart.orderType == OrderType.delivery ? AppTheme.gold : AppTheme.mutedText,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Pickup Option (with store_image.webp)
                Expanded(
                  child: GestureDetector(
                    onTap: () => cart.setOrderType(OrderType.pickup),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: cart.orderType == OrderType.pickup ? AppTheme.primaryGreen : AppTheme.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: cart.orderType == OrderType.pickup ? AppTheme.primaryGreen : AppTheme.border,
                          width: 1.5,
                        ),
                        boxShadow: cart.orderType == OrderType.pickup ? AppTheme.greenShadow : AppTheme.softShadow,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cart.orderType == OrderType.pickup
                                  ? Colors.white
                                  : AppTheme.creamDark,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/store_image.webp',
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.storefront, color: AppTheme.primaryGreen, size: 28),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang.isFrench ? "À emporter" : "Takeaway",
                            style: TextStyle(
                              color: cart.orderType == OrderType.pickup ? Colors.white : AppTheme.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            lang.isFrench ? "Retrait gratuit" : "Free pickup",
                            style: TextStyle(
                              color: cart.orderType == OrderType.pickup ? Colors.white70 : AppTheme.mutedText,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Order Summary Bill Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.isFrench ? "Sous-total" : "Subtotal",
                        style: const TextStyle(color: AppTheme.mutedText, fontSize: 14),
                      ),
                      Text(
                        "${restaurant.currencySymbol}${cart.subtotal.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cart.orderType == OrderType.delivery
                            ? (lang.isFrench ? "Frais de livraison" : "Delivery fee")
                            : (lang.isFrench ? "Frais de retrait" : "Pickup fee"),
                        style: const TextStyle(color: AppTheme.mutedText, fontSize: 14),
                      ),
                      Text(
                        deliveryFee > 0
                            ? "${restaurant.currencySymbol}${deliveryFee.toStringAsFixed(2)}"
                            : (lang.isFrench ? "Gratuit" : "Free"),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: deliveryFee > 0 ? AppTheme.black : AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppTheme.border),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOTAL",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Text(
                        "${restaurant.currencySymbol}${grandTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Proceed to Checkout Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lang.isFrench ? "Passer à la Caisse" : "Proceed to Checkout",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
