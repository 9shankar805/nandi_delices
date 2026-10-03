import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';

class FoodCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();
    final quantityInCart = cart.getItemQuantity(item.id);

    final primaryName = lang.isFrench ? item.nameFr : item.nameEn;
    final secondaryName = lang.isFrench ? item.nameEn : item.nameFr;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECE7DB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Food Image with Floating Glass Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(19),
                      topRight: Radius.circular(19),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 11,
                      child: item.image != null && item.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: item.image!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppTheme.creamDark,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppTheme.creamDark,
                                child: const Center(
                                  child: Icon(Icons.restaurant, color: AppTheme.primaryGreen, size: 32),
                                ),
                              ),
                            )
                          : Container(
                              color: AppTheme.creamDark,
                              child: const Center(
                                child: Icon(Icons.restaurant, color: AppTheme.primaryGreen, size: 32),
                              ),
                            ),
                    ),
                  ),

                  // Subtle gradient overlay at the top for badge readability
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(19),
                          topRight: Radius.circular(19),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withAlpha(80),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Floating Badges (Top Left)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.isVegetarian)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(40),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.eco, color: Colors.white, size: 10),
                                SizedBox(width: 2),
                                Text(
                                  "Veg",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (item.popular)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD54F), Color(0xFFF4C400)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(40),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: AppTheme.black, size: 10),
                                const SizedBox(width: 2),
                                Text(
                                  lang.isFrench ? "Populaire" : "Popular",
                                  style: const TextStyle(
                                    color: AppTheme.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Spice level (Top Right)
                  if (item.spiceLevel > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD71920),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "🌶️" * item.spiceLevel,
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                ],
              ),

              // 2. Card Content (Title, Subtitle, Price & Action)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dish Titles
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            primaryName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: AppTheme.black,
                              height: 1.2,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            secondaryName,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF7A7569),
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      // 3. Price & Action Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.isSurCommande)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFFFB74D)),
                                    ),
                                    child: Text(
                                      lang.isFrench ? "Sur commande" : "On Order",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFE65100),
                                      ),
                                    ),
                                  )
                                else ...[
                                  Text(
                                    item.formattedPrice(restaurant.currencySymbol),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: AppTheme.primaryGreen,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Text(
                                    "/ ${item.unit}",
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF8A8478),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Action: + Add or Stepper
                          quantityInCart == 0
                              ? InkWell(
                                  onTap: () {
                                    cart.addItem(item);
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${lang.isFrench ? 'Ajouté' : 'Added'}: $primaryName"),
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: AppTheme.primaryGreen,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryGreen.withAlpha(60),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.add, color: Colors.white, size: 15),
                                        const SizedBox(width: 3),
                                        Text(
                                          lang.isFrench ? "Ajouter" : "Add",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.creamDark,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.primaryGreen, width: 1.2),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        onTap: () => cart.decrementQuantity(item.id),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Icon(Icons.remove, size: 14, color: AppTheme.warmRed),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 3),
                                        child: Text(
                                          "$quantityInCart",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color: AppTheme.black,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        onTap: () => cart.incrementQuantity(item.id),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Icon(Icons.add, size: 14, color: AppTheme.primaryGreen),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
