import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/language_provider.dart';
import '../providers/restaurant_provider.dart';

class HeroBannerCard extends StatefulWidget {
  final VoidCallback onOrderNowPressed;

  const HeroBannerCard({
    super.key,
    required this.onOrderNowPressed,
  });

  @override
  State<HeroBannerCard> createState() => _HeroBannerCardState();
}

class _HeroBannerCardState extends State<HeroBannerCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _sliderImages = [
    'assets/images/store_image.webp',
    'assets/images/hero_banner.jpg',
    'assets/images/splash_screen_full.webp',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _sliderImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>().config;
    final lang = context.watch<LanguageProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.greenShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Background Image Slider
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _sliderImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _sliderImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.heroGradient,
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Subtle Dark Gradient Overlay (Natural image clarity)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(70),
                    Colors.black.withAlpha(130),
                    Colors.black.withAlpha(190),
                  ],
                ),
              ),
            ),
          ),

          // 3. Decorative subtle gold glow
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.gold.withAlpha(35),
              ),
            ),
          ),

          // 4. Hero Foreground Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with logo and status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mascot Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: AppTheme.softShadow,
                        border: Border.all(color: AppTheme.gold, width: 2.2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/logo.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Center(
                          child: Icon(Icons.restaurant, color: AppTheme.primaryGreen, size: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.2,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.gold,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  restaurant.tagline.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.black,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: restaurant.isOpen ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.isOpen
                                    ? (lang.isFrench ? "Ouvert" : "Open Now")
                                    : (lang.isFrench ? "Fermé" : "Closed"),
                                style: TextStyle(
                                  color: restaurant.isOpen ? Colors.white70 : const Color(0xFFFFCDD2),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Subtitle description
                Text(
                  lang.isFrench
                      ? "Cuisine maison créole & mauricienne authentique. Commandez directement en quelques clics via WhatsApp !"
                      : "Authentic homemade Mauritian Creole cuisine. Order directly in just a few taps via WhatsApp!",
                  style: TextStyle(
                    color: Colors.white.withAlpha(235),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                // Order Action Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onOrderNowPressed,
                        icon: const Icon(Icons.restaurant_menu, size: 18, color: AppTheme.black),
                        label: Text(
                          lang.isFrench ? "Commander Maintenant" : "Order Now",
                          style: const TextStyle(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          foregroundColor: AppTheme.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Slider Dot Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_sliderImages.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 20 : 6,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isActive ? AppTheme.gold : Colors.white.withAlpha(100),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
