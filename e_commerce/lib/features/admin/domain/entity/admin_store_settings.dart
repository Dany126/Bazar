class AdminStoreSettings {
  final String storeName;
  final String description;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String country;
  final String postalCode;

  final String currency;

  final double taxRate;
  final double shippingFee;
  final double freeShippingThreshold;
  final double minimumOrderAmount;

  final int lowStockThreshold;

  final bool storeEnabled;
  final bool acceptOrders;

  const AdminStoreSettings({
    required this.storeName,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.currency,
    required this.taxRate,
    required this.shippingFee,
    required this.freeShippingThreshold,
    required this.minimumOrderAmount,
    required this.lowStockThreshold,
    required this.storeEnabled,
    required this.acceptOrders,
  });

  factory AdminStoreSettings.fromJson(Map<String, dynamic> json) {
    double doubleValue(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }

      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    int intValue(dynamic value) {
      if (value is num) {
        return value.toInt();
      }

      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    bool boolValue(dynamic value) {
      if (value is bool) {
        return value;
      }

      if (value is String) {
        return value.toLowerCase() == 'true';
      }

      return false;
    }

    return AdminStoreSettings(
      storeName: json['storeName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'EGP',
      taxRate: doubleValue(json['taxRate']),
      shippingFee: doubleValue(json['shippingFee']),
      freeShippingThreshold: doubleValue(json['freeShippingThreshold']),
      minimumOrderAmount: doubleValue(json['minimumOrderAmount']),
      lowStockThreshold: intValue(json['lowStockThreshold']),
      storeEnabled: boolValue(json['storeEnabled']),
      acceptOrders: boolValue(json['acceptOrders']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'description': description,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'currency': currency,
      'taxRate': taxRate,
      'shippingFee': shippingFee,
      'freeShippingThreshold': freeShippingThreshold,
      'minimumOrderAmount': minimumOrderAmount,
      'lowStockThreshold': lowStockThreshold,
      'storeEnabled': storeEnabled,
      'acceptOrders': acceptOrders,
    };
  }
}
