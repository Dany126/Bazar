

import 'package:e_commerce/features/payment_method/domain/entity/saved_card_entity.dart';

abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentLoaded extends PaymentState {
  const PaymentLoaded({required this.cards, this.selectedCardId});
  final List<SavedCardEntity> cards;
  final String? selectedCardId;

  PaymentLoaded copyWith({
    List<SavedCardEntity>? cards,
    String? selectedCardId,
    bool clearSelected = false,
  }) {
    return PaymentLoaded(
      cards: cards ?? this.cards,
      selectedCardId: clearSelected
          ? null
          : (selectedCardId ?? this.selectedCardId),
    );
  }
}

class PaymentError extends PaymentState {
  const PaymentError(this.message);
  final String message;
}
