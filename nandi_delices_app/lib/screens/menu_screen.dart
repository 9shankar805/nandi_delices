import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/food_card.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/closed_restaurant_banner.dart';
import 'item_detail_sheet.dart';

class MenuScreen extends StatelessWidget {
  final VoidCallback onNavigateToCart;

  const MenuScreen({super.key, required this.onNavigateToCart});

  void _showItemDetail(BuildContext context, MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuProvider>();
    final cart = context.watch<CartProvider>();
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.restaurant, color: AppTheme.primaryGreen),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.isFrench ? "Notre Carte" : "Our Menu",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  lang.isFrench ? "Menu & Spécialités" : "Dishes & Specialties",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const LanguageToggleButton(),
          // Cart badge button
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.black, size: 26),
                onPressed: onNavigateToCart,
              ),
              if (cart.totalItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.warmRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      "${cart.totalItemCount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search & Filter Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: menu.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: lang.isFrench
                            ? "Rechercher un plat (ex: Curry, Samoussa)..."
                            : "Search dishes (e.g. Curry, Samosas)...",
                        prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText),
                        suffixIcon: menu.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppTheme.mutedText),
                                onPressed: () => menu.setSearchQuery(''),
                              )
                            : null,
                        fillColor: AppTheme.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Quick Filter Badges
                    Row(
                      children: [
                        FilterChip(
                          selected: menu.onlyVegetarian,
                          label: Text(lang.isFrench ? "🌱 Végétarien" : "🌱 Vegetarian"),
                          onSelected: (val) => menu.toggleVegetarianFilter(),
                          backgroundColor: AppTheme.white,
                          selectedColor: const Color(0xFFE8F5E9),
                          checkmarkColor: const Color(0xFF2E7D32),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: menu.onlyVegetarian ? const Color(0xFF2E7D32) : AppTheme.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: menu.onlyVegetarian ? const Color(0xFF2E7D32) : AppTheme.border,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          selected: menu.onlySpicy,
                          label: Text(lang.isFrench ? "🌶️ Épicé" : "🌶️ Spicy"),
                          onSelected: (val) => menu.toggleSpicyFilter(),
                          backgroundColor: AppTheme.white,
                          selectedColor: const Color(0xFFFFEBEE),
                          checkmarkColor: AppTheme.warmRed,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: menu.onlySpicy ? AppTheme.warmRed : AppTheme.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: menu.onlySpicy ? AppTheme.warmRed : AppTheme.border,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Closed Banner (if closed)
              const ClosedRestaurantBanner(),

              // Category Tabs
              const CategorySelector(),

              const SizedBox(height: 12),

              // Menu Grid
              Expanded(
                child: menu.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                      )
                    : menu.filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, size: 64, color: AppTheme.mutedText),
                                const SizedBox(height: 12),
                                Text(
                                  lang.isFrench ? "Aucun plat trouvé" : "No dishes found",
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lang.isFrench
                                      ? "Essayez un autre mot-clé ou filtre"
                                      : "Try searching with another keyword or filter",
                                  style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {
                                    menu.setSearchQuery('');
                                    if (menu.onlyVegetarian) menu.toggleVegetarianFilter();
                                    if (menu.onlySpicy) menu.toggleSpicyFilter();
                                    menu.selectCategory('all');
                                  },
                                  child: Text(lang.isFrench ? "Réinitialiser les filtres" : "Reset Filters"),
                                ),
                              ],
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
                              return GridView.builder(
                                padding: EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  cart.totalItemCount > 0 ? 90 : 20,
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.65,
                                ),
                                itemCount: menu.filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = menu.filteredItems[index];
                                  return FoodCard(
                                    item: item,
                                    onTap: () => _showItemDetail(context, item),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),

          // Sticky Cart Float Bar at Bottom (when items in cart)
          if (cart.totalItemCount > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: onNavigateToCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: AppTheme.greenShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.gold,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${cart.totalItemCount}",
                          style: const TextStyle(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lang.isFrench ? "Voir le Panier" : "View Cart",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              lang.isFrench ? "Commander sur WhatsApp" : "Checkout with WhatsApp",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${restaurant.currencySymbol}${cart.subtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
