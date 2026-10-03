import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/menu_item.dart';

class MenuCategory {
  final String id;
  final String nameFr;
  final String nameEn;
  final String icon;

  const MenuCategory({
    required this.id,
    required this.nameFr,
    required this.nameEn,
    required this.icon,
  });
}

class MenuProvider extends ChangeNotifier {
  List<MenuItem> _allItems = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _onlyVegetarian = false;
  bool _onlySpicy = false;
  bool _isLoading = true;

  final List<MenuCategory> categories = const [
    MenuCategory(id: 'all', nameFr: 'Tout le menu', nameEn: 'All Menu', icon: '✨'),
    MenuCategory(id: 'starters', nameFr: 'Snacks / Entrées', nameEn: 'Snacks & Starters', icon: '🥟'),
    MenuCategory(id: 'main-dishes', nameFr: 'Plats principaux', nameEn: 'Main Dishes', icon: '🍛'),
    MenuCategory(id: 'special', nameFr: 'Spécial / Commande', nameEn: 'Special / On Order', icon: '⭐'),
    MenuCategory(id: 'desserts', nameFr: 'Desserts', nameEn: 'Desserts & Sweets', icon: '🥥'),
  ];

  List<MenuItem> get allItems => _allItems;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get onlyVegetarian => _onlyVegetarian;
  bool get onlySpicy => _onlySpicy;
  bool get isLoading => _isLoading;

  MenuProvider() {
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('assets/data/menu.json');
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is List) {
        _allItems = decoded.map((raw) {
          final map = raw as Map<String, dynamic>;
          final id = map['id']?.toString() ?? '';
          final cat = map['category'] as String? ?? 'main-dishes';
          final nameFr = map['nameFr'] as String? ?? '';
          final nameEn = map['nameEn'] as String? ?? '';
          final priceNum = (map['price'] as num?)?.toDouble();
          final unit = map['unit'] as String? ?? 'pièce';

          // Curated descriptions, dietary info and images
          final enriched = _enrichItemData(id, cat, nameFr, nameEn, priceNum, unit);
          return enriched;
        }).toList();
      }
    } catch (e) {
      debugPrint('Error loading menu.json: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleVegetarianFilter() {
    _onlyVegetarian = !_onlyVegetarian;
    notifyListeners();
  }

  void toggleSpicyFilter() {
    _onlySpicy = !_onlySpicy;
    notifyListeners();
  }

  int getCategoryCount(String categoryId) {
    if (categoryId == 'all') return _allItems.length;
    return _allItems.where((item) => item.category == categoryId).length;
  }

  List<MenuItem> get filteredItems {
    return _allItems.where((item) {
      // Category filter
      if (_selectedCategory != 'all' && item.category != _selectedCategory) {
        return false;
      }
      // Search query filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchFr = item.nameFr.toLowerCase().contains(query);
        final matchEn = item.nameEn.toLowerCase().contains(query);
        final matchDesc = (item.descriptionFr ?? '').toLowerCase().contains(query) ||
            (item.descriptionEn ?? '').toLowerCase().contains(query);
        if (!matchFr && !matchEn && !matchDesc) return false;
      }
      // Vegetarian filter
      if (_onlyVegetarian && !item.isVegetarian) {
        return false;
      }
      // Spicy filter
      if (_onlySpicy && item.spiceLevel < 1) {
        return false;
      }
      return true;
    }).toList();
  }

  List<MenuItem> get popularDishes {
    return _allItems.where((item) => item.popular).toList();
  }

  MenuItem _enrichItemData(
    String id,
    String category,
    String nameFr,
    String nameEn,
    double? price,
    String unit,
  ) {
    bool isVeg = false;
    bool isPopular = false;
    int spice = 0;
    String? descFr;
    String? descEn;
    String img = 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=600&q=80';

    final lowerName = '$nameFr $nameEn'.toLowerCase();

    // Dietary & spice logic
    if (lowerName.contains('légumes') ||
        lowerName.contains('fromages') ||
        lowerName.contains('chèvre') ||
        lowerName.contains('feta') ||
        lowerName.contains('piment') ||
        lowerName.contains('choux') ||
        lowerName.contains('coco') ||
        lowerName.contains('maïs') ||
        lowerName.contains('semoule') ||
        lowerName.contains('riz créole') ||
        lowerName.contains('achard')) {
      isVeg = true;
    }

    if (lowerName.contains('piment') || lowerName.contains('spicy') || lowerName.contains('rougail') || lowerName.contains('vindaye')) {
      spice = 3;
    } else if (lowerName.contains('curry') || lowerName.contains('haleem') || lowerName.contains('biryani')) {
      spice = 2;
    } else if (lowerName.contains('samoussas') || lowerName.contains('sauté') || lowerName.contains('nouilles')) {
      spice = 1;
    }

    if (id == "1" || id == "13" || id == "14" || id == "16" || id == "19" || id == "27" || id == "31" || id == "34" || id == "35") {
      isPopular = true;
    }

    // Curated high quality food photos
    if (lowerName.contains('samoussas') || lowerName.contains('samosas')) {
      img = 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80';
      descFr = 'Samoussas croustillants dorés faits maison avec garniture parfumée.';
      descEn = 'Handcrafted golden crispy samosas filled with fragrant spices.';
    } else if (lowerName.contains('bouchon') || lowerName.contains('boulette')) {
      img = 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?auto=format&fit=crop&w=600&q=80';
      descFr = 'Bouchons vapeur mauriciens et boulettes savoureuses.';
      descEn = 'Traditional steamed chicken dumplings and savory bouchons.';
    } else if (lowerName.contains('bonbon piment') || lowerName.contains('beignet')) {
      img = 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=600&q=80';
      descFr = 'Beignets croustillants traditionnels de pois cassés et piments verts.';
      descEn = 'Famous Mauritian crunchy split-pea chili fritters.';
    } else if (lowerName.contains('nems')) {
      img = 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80';
      descFr = 'Rouleaux de printemps croustillants avec sauce aigre-douce.';
      descEn = 'Crisp spring rolls served with homemade sweet chili sauce.';
    } else if (lowerName.contains('curry poulet') || lowerName.contains('chicken curry')) {
      img = 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=600&q=80';
      descFr = 'Curry de poulet mijoté à l\'ancienne avec masala maison et pommes de terre.';
      descEn = 'Slow-cooked traditional chicken curry in Mauritian masala.';
    } else if (lowerName.contains('agneau') || lowerName.contains('lamb')) {
      img = 'https://images.unsplash.com/photo-1545247181-516773cae754?auto=format&fit=crop&w=600&q=80';
      descFr = 'Morceaux d\'agneau tendres dans une sauce riche aux épices torréfiées.';
      descEn = 'Tender spiced lamb simmered in roasted Mauritian spices.';
    } else if (lowerName.contains('crevette') || lowerName.contains('shrimp')) {
      img = 'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=600&q=80';
      descFr = 'Crevettes juteuses sautées ou en curry doux au lait de coco.';
      descEn = 'Juicy prawns simmered with fresh herbs and coconut cream.';
    } else if (lowerName.contains('rougail') || lowerName.contains('saucisse')) {
      img = 'https://images.unsplash.com/photo-1541832676-9b763b0239ab?auto=format&fit=crop&w=600&q=80';
      descFr = 'Rougail créole mijoté aux saucisses fumées, thym et tomates fraîches.';
      descEn = 'Signature Creole stew with smoked sausage, garlic, and fresh tomatoes.';
    } else if (lowerName.contains('nouilles') || lowerName.contains('mines')) {
      img = 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80';
      descFr = 'Mines frites mauriciennes sautées au wok avec légumes et œuf.';
      descEn = 'Wok-tossed Mauritian noodles with crisp seasonal vegetables.';
    } else if (lowerName.contains('riz frit') || lowerName.contains('fried rice')) {
      img = 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=600&q=80';
      descFr = 'Riz sauté au wok parfumé à l\'huile de sésame et ciboulette.';
      descEn = 'Fragrant wok-fried rice with spring onions and homemade sauce.';
    } else if (lowerName.contains('vindaye') || lowerName.contains('poulpe') || lowerName.contains('octopus')) {
      img = 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=600&q=80';
      descFr = 'Poulpe mariné au curcuma, graines de moutarde et piments verts doux.';
      descEn = 'Pickled octopus specialty with mustard seeds, turmeric & chilies.';
    } else if (lowerName.contains('haleem')) {
      img = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=600&q=80';
      descFr = 'Soupe réconfortante de lentilles, blé cassé et viande marinée.';
      descEn = 'Hearty, slow-cooked lentil and meat soup served piping hot.';
    } else if (lowerName.contains('biryani')) {
      img = 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80';
      descFr = 'Grand festin mauricien cuit à l\'étouffée et galettes chaudes de Dholl Puri.';
      descEn = 'Traditional royal dum biryani and freshly rolled hot dholl puri.';
    } else if (lowerName.contains('coco')) {
      img = 'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=600&q=80';
      descFr = 'Douceurs roulées dans de la noix de coco fraîche râpée.';
      descEn = 'Delicious sweet coconut balls flavored with cardamom.';
    } else if (lowerName.contains('maïs') || lowerName.contains('pudding')) {
      img = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80';
      descFr = 'Pudding fondant à la fécule de maïs, vanille et lait de coco.';
      descEn = 'Silky traditional cornflour and coconut vanilla pudding cake.';
    } else if (lowerName.contains('oundé') || lowerName.contains('semoule')) {
      img = 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80';
      descFr = 'Friandises de semoule de blé torréfiée au ghee et cardamome.';
      descEn = 'Toasted semolina sweet laddoos infused with pure ghee.';
    }

    return MenuItem(
      id: id,
      category: category,
      nameFr: nameFr,
      nameEn: nameEn,
      descriptionFr: descFr,
      descriptionEn: descEn,
      price: price,
      unit: unit,
      available: true,
      isVegetarian: isVeg,
      isSpecialOrder: category == 'special' || price == null,
      spiceLevel: spice,
      popular: isPopular,
      image: img,
    );
  }
}
