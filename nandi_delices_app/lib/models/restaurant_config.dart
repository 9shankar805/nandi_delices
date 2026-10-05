class RestaurantConfig {
  final String name;
  final String tagline;
  final String subtitle;
  final String whatsappNumber; // e.g. "33652764960" without spaces
  final String phone;
  final String currency;
  final String currencySymbol;
  final double deliveryFee;
  final String address;
  final String openingHours;
  final bool isOpen;

  const RestaurantConfig({
    this.name = "Nandi Delices",
    this.tagline = "Home Style Food",
    this.subtitle = "Saveurs authentiques & Fait Maison",
    this.whatsappNumber = "33652764960",
    this.phone = "+33 6 52 76 49 60",
    this.currency = "EUR",
    this.currencySymbol = "€",
    this.deliveryFee = 2.00,
    this.address = "Nandi Delices, 75010 Paris",
    this.openingHours = "Mar – Dim : 11h30 – 15h00 & 18h30 – 22h30",
    this.isOpen = true,
  });

  RestaurantConfig copyWith({
    String? name,
    String? tagline,
    String? subtitle,
    String? whatsappNumber,
    String? phone,
    String? currency,
    String? currencySymbol,
    double? deliveryFee,
    String? address,
    String? openingHours,
    bool? isOpen,
  }) {
    return RestaurantConfig(
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      subtitle: subtitle ?? this.subtitle,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      phone: phone ?? this.phone,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  factory RestaurantConfig.fromJson(Map<String, dynamic> json) {
    return RestaurantConfig(
      name: json['name'] as String? ?? "Nandi Delices",
      tagline: json['tagline'] as String? ?? "Home Style Food",
      subtitle: json['subtitle'] as String? ?? "Saveurs authentiques & Fait Maison",
      whatsappNumber: json['whatsappNumber'] as String? ?? "33652764960",
      phone: json['phone'] as String? ?? "+33 6 52 76 49 60",
      currency: json['currency'] as String? ?? "EUR",
      currencySymbol: json['currencySymbol'] as String? ?? "€",
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 2.00,
      address: json['address'] as String? ?? "Nandi Delices, Paris",
      openingHours: json['openingHours'] as String? ?? "Mar – Dim : 11h30 – 15h00 & 18h30 – 22h30",
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagline': tagline,
      'subtitle': subtitle,
      'whatsappNumber': whatsappNumber,
      'phone': phone,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'deliveryFee': deliveryFee,
      'address': address,
      'openingHours': openingHours,
      'isOpen': isOpen,
    };
  }
}
