import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/hero_banner_card.dart';
import '../widgets/food_card.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/closed_restaurant_banner.dart';
import 'menu_screen.dart';
import 'cart_screen.dart';
import 'about_screen.dart';
import 'item_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
    final cart = context.watch<CartProvider>();
    final lang = context.watch<LanguageProvider>();

    final pages = [
      _HomeTabContent(
        onExploreMenu: () => _navigateToTab(1),
        onItemTapped: (item) => _showItemDetail(context, item),
      ),
      MenuScreen(onNavigateToCart: () => _navigateToTab(2)),
      CartScreen(onBrowseMenu: () => _navigateToTab(1)),
      const AboutScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: const Border(top: BorderSide(color: AppTheme.border, width: 1)),
          boxShadow: AppTheme.softShadow,
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _navigateToTab,
          backgroundColor: AppTheme.white,
          indicatorColor: AppTheme.gold.withAlpha(80),
          height: 65,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: AppTheme.primaryGreen),
              label: lang.isFrench ? "Accueil" : "Home",
            ),
            NavigationDestination(
              icon: const Icon(Icons.restaurant_menu_outlined),
              selectedIcon: const Icon(Icons.restaurant_menu, color: AppTheme.primaryGreen),
              label: lang.isFrench ? "Carte" : "Menu",
            ),
            NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  if (cart.totalItemCount > 0)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.warmRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          "${cart.totalItemCount}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              selectedIcon: const Icon(Icons.shopping_bag, color: AppTheme.primaryGreen),
              label: lang.isFrench ? "Panier" : "Cart",
            ),
            NavigationDestination(
              icon: const Icon(Icons.info_outline),
              selectedIcon: const Icon(Icons.info, color: AppTheme.primaryGreen),
              label: lang.isFrench ? "Contact" : "About",
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  final VoidCallback onExploreMenu;
  final Function(MenuItem) onItemTapped;

  const _HomeTabContent({
    required this.onExploreMenu,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuProvider>();
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
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
                  restaurant.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                ),
                Text(
                  restaurant.tagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: AppTheme.mutedText,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          LanguageToggleButton(),
          SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Banner Card
            HeroBannerCard(onOrderNowPressed: onExploreMenu),

            // Closed banner (displayed only when restaurant is closed)
            const ClosedRestaurantBanner(),

            const SizedBox(height: 8),

            // How It Works Step Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStep(
                    context,
                    "1",
                    lang.isFrench ? "Choisissez" : "Select",
                    lang.isFrench ? "Sur la carte" : "Browse menu",
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.border),
                  _buildStep(
                    context,
                    "2",
                    lang.isFrench ? "Remplissez" : "Fill Cart",
                    lang.isFrench ? "Votre panier" : "Add to cart",
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.border),
                  _buildStep(
                    context,
                    "3",
                    "WhatsApp",
                    lang.isFrench ? "Envoi 1-clic" : "1-tap order",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Categories Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.isFrench ? "Catégories" : "Categories",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.black),
                  ),
                  TextButton(
                    onPressed: onExploreMenu,
                    child: Row(
                      children: [
                        Text(
                          lang.isFrench ? "Tout voir" : "View All",
                          style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w700),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AppTheme.primaryGreen),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Categories 4-Pill Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryCard(context, menu, "starters", "🥟", lang.isFrench ? "Snacks" : "Starters", "12"),
                  const SizedBox(width: 8),
                  _buildCategoryCard(context, menu, "main-dishes", "🍛", lang.isFrench ? "Plats" : "Mains", "21"),
                  const SizedBox(width: 8),
                  _buildCategoryCard(context, menu, "special", "⭐", lang.isFrench ? "Spécial" : "Special", "1"),
                  const SizedBox(width: 8),
                  _buildCategoryCard(context, menu, "desserts", "🥥", "Desserts", "3"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Popular Dishes Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.isFrench ? "Spécialités Populaires" : "Popular Specialties",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.black),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "MUST TRY",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.black),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Popular Items Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: menu.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
                        final populars = menu.popularDishes;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: populars.length,
                          itemBuilder: (context, index) {
                            final item = populars[index];
                            return FoodCard(
                              item: item,
                              onTap: () => onItemTapped(item),
                            );
                          },
                        );
                      },
                    ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String title, String sub) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withAlpha(40),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppTheme.black)),
        Text(sub, style: const TextStyle(fontSize: 9, color: AppTheme.mutedText)),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    MenuProvider menu,
    String categoryId,
    String emoji,
    String title,
    String count,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          menu.selectCategory(categoryId);
          onExploreMenu();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppTheme.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                "$count items",
                style: const TextStyle(fontSize: 9, color: AppTheme.mutedText, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
