enum CardBrand { visa, mastercard, other }

class SavedCardEntity {
  const SavedCardEntity({
    required this.id,
    required this.last4,
    required this.brand,
    required this.cardholderName,
    required this.expiry,
    this.isDefault = false,
  });

  final String id;
  final String last4;
  final CardBrand brand;
  final String cardholderName;
  final String expiry;
  final bool isDefault;
}

/// Very rough brand detection from the first digit — good enough while
/// there's no backend/BIN lookup; swap out once the real API is wired in.
CardBrand detectCardBrand(String cardNumber) {
  final digitsOnly = cardNumber.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.isEmpty) return CardBrand.other;
  if (digitsOnly.startsWith('4')) return CardBrand.visa;
  if (digitsOnly.startsWith('5')) return CardBrand.mastercard;
  return CardBrand.other;
}
