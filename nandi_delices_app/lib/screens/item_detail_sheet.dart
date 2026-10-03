import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';

class ItemDetailSheet extends StatefulWidget {
  final MenuItem item;

  const ItemDetailSheet({super.key, required this.item});

  @override
  State<ItemDetailSheet> createState() => _ItemDetailSheetState();
}

class _ItemDetailSheetState extends State<ItemDetailSheet> {
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();
    final item = widget.item;
    final totalPrice = (item.price ?? 0.0) * _quantity;

    final primaryName = lang.isFrench ? item.nameFr : item.nameEn;
    final secondaryName = lang.isFrench ? item.nameEn : item.nameFr;
    final desc = lang.isFrench ? (item.descriptionFr ?? '') : (item.descriptionEn ?? item.descriptionFr ?? '');

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image with drag handle
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: item.image != null && item.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: item.image!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppTheme.creamDark,
                              child: const Center(
                                child: Icon(Icons.restaurant, color: AppTheme.primaryGreen, size: 48),
                              ),
                            ),
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Pill tags
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        if (item.isVegetarian)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              lang.isFrench ? "🌱 Végétarien" : "🌱 Vegetarian",
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        if (item.spiceLevel > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.warmRed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${lang.isFrench ? 'Épicé' : 'Spicy'} ${"🌶️" * item.spiceLevel}",
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dish name
                    Text(
                      primaryName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      secondaryName,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.mutedText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Price & Unit
                    Row(
                      children: [
                        Text(
                          item.isSurCommande
                              ? (lang.isFrench ? "Sur commande" : "On Order")
                              : item.formattedPrice(restaurant.currencySymbol),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        if (!item.isSurCommande)
                          Text(
                            " / ${item.unit}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.mutedText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppTheme.border),
                    const SizedBox(height: 12),

                    // Description
                    if (desc.isNotEmpty) ...[
                      Text(
                        lang.isFrench ? "Description" : "About this dish",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        style: const TextStyle(color: AppTheme.black, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Special Notes
                    Text(
                      lang.isFrench
                          ? "Instructions spéciales (Optionnel)"
                          : "Special instructions (Optional)",
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: lang.isFrench
                            ? "Ex: Sans coriandre, peu pimenté..."
                            : "e.g. Mildly spicy, no cilantro...",
                        fillColor: AppTheme.cream,
                        prefixIcon: const Icon(Icons.note_alt_outlined, color: AppTheme.mutedText, size: 20),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 20),

                    // Quantity Stepper & Add Button
                    Row(
                      children: [
                        // Quantity controller
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.creamDark,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "$_quantity",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () {
                                  setState(() => _quantity++);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Add to Cart Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final note = _noteController.text.trim();
                              cart.addItem(item, quantity: _quantity, note: note.isNotEmpty ? note : null);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    lang.isFrench
                                        ? "Ajouté au panier: $_quantity × $primaryName"
                                        : "Added to cart: $_quantity × $primaryName",
                                  ),
                                  backgroundColor: AppTheme.primaryGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              item.isSurCommande
                                  ? (lang.isFrench ? "Ajouter au panier" : "Add to Cart")
                                  : "${lang.isFrench ? 'Ajouter' : 'Add'} • ${restaurant.currencySymbol}${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
