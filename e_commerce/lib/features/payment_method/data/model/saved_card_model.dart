import '../../domain/entity/saved_card_entity.dart';

class SavedCardModel extends SavedCardEntity {
  const SavedCardModel({
    required super.id,
    required super.last4,
    required super.brand,
    required super.cardholderName,
    required super.expiry,
  });

  factory SavedCardModel.fromEntity(SavedCardEntity entity) => SavedCardModel(
    id: entity.id,
    last4: entity.last4,
    brand: entity.brand,
    cardholderName: entity.cardholderName,
    expiry: entity.expiry,
  );
}
