class MenuItem {
  final String id;
  final String category;
  final String nameFr;
  final String nameEn;
  final String? descriptionFr;
  final String? descriptionEn;
  final double? price;
  final String unit;
  final bool available;
  final bool isVegetarian;
  final bool isSpecialOrder;
  final int spiceLevel; // 0: None, 1: Mild, 2: Medium, 3: Spicy
  final bool popular;
  final String? image;

  const MenuItem({
    required this.id,
    required this.category,
    required this.nameFr,
    required this.nameEn,
    this.descriptionFr,
    this.descriptionEn,
    this.price,
    required this.unit,
    this.available = true,
    this.isVegetarian = false,
    this.isSpecialOrder = false,
    this.spiceLevel = 0,
    this.popular = false,
    this.image,
  });

  bool get isSurCommande => price == null || unit.toLowerCase().contains('commande');

  String formattedPrice([String symbol = '€']) {
    if (isSurCommande || price == null) {
      return 'Sur commande';
    }
    // format as €1.00 or €3.80
    return '$symbol${price!.toStringAsFixed(price! % 1 == 0 ? 2 : 2)}';
  }

  String formattedPriceWithUnit([String symbol = '€']) {
    if (isSurCommande || price == null) {
      return 'Sur commande';
    }
    return '${formattedPrice(symbol)} / $unit';
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    double? parsedPrice;
    if (rawPrice != null) {
      if (rawPrice is num) {
        parsedPrice = rawPrice.toDouble();
      } else if (rawPrice is String) {
        parsedPrice = double.tryParse(rawPrice);
      }
    }

    final cat = json['category'] as String? ?? 'main-dishes';
    final nameFr = json['nameFr'] as String? ?? '';
    final nameEn = json['nameEn'] as String? ?? '';
    final unit = json['unit'] as String? ?? 'pièce';

    return MenuItem(
      id: json['id']?.toString() ?? '',
      category: cat,
      nameFr: nameFr,
      nameEn: nameEn,
      descriptionFr: json['descriptionFr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      price: parsedPrice,
      unit: unit,
      available: json['available'] as bool? ?? true,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isSpecialOrder: json['isSpecialOrder'] as bool? ?? (cat == 'special' || parsedPrice == null),
      spiceLevel: json['spiceLevel'] as int? ?? 0,
      popular: json['popular'] as bool? ?? false,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'nameFr': nameFr,
      'nameEn': nameEn,
      'descriptionFr': descriptionFr,
      'descriptionEn': descriptionEn,
      'price': price,
      'unit': unit,
      'available': available,
      'isVegetarian': isVegetarian,
      'isSpecialOrder': isSpecialOrder,
      'spiceLevel': spiceLevel,
      'popular': popular,
      'image': image,
    };
  }
}
