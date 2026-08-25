import 'package:e_commerce/features/payment_method/domain/use_case/add_card_use_case.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/get_saved_cards_use_case.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/remove_card_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({
    required this.getSavedCardsUseCase,
    required this.addCardUseCase,
    required this.removeCardUseCase,
  }) : super(const PaymentInitial());

  final GetSavedCardsUseCase getSavedCardsUseCase;
  final AddCardUseCase addCardUseCase;
  final RemoveCardUseCase removeCardUseCase;

  Future<void> loadCards() async {
    emit(const PaymentLoading());
    final result = await getSavedCardsUseCase();
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (cards) => emit(
        PaymentLoaded(
          cards: cards,
          selectedCardId: cards.isNotEmpty ? cards.first.id : null,
        ),
      ),
    );
  }

  Future<void> addCard({
    required String cardNumber,
    required String ccv,
    required String expiry,
    required String cardholderName,
  }) async {
    final result = await addCardUseCase(
      cardNumber: cardNumber,
      ccv: ccv,
      expiry: expiry,
      cardholderName: cardholderName,
    );
    result.fold((failure) => emit(PaymentError(failure.message)), (card) {
      final current = state is PaymentLoaded ? state as PaymentLoaded : null;
      emit(
        PaymentLoaded(
          cards: [...?current?.cards, card],
          selectedCardId: current?.selectedCardId ?? card.id,
        ),
      );
    });
  }

  Future<void> removeCard(String id) async {
    final current = state is PaymentLoaded ? state as PaymentLoaded : null;
    if (current == null) return;

    final result = await removeCardUseCase(id);
    result.fold((failure) => emit(PaymentError(failure.message)), (_) {
      final updatedCards = current.cards.where((c) => c.id != id).toList();
      final wasSelected = current.selectedCardId == id;
      emit(
        PaymentLoaded(
          cards: updatedCards,
          selectedCardId: wasSelected
              ? (updatedCards.isNotEmpty ? updatedCards.first.id : null)
              : current.selectedCardId,
        ),
      );
    });
  }

  void selectCard(String id) {
    final current = state is PaymentLoaded ? state as PaymentLoaded : null;
    if (current == null) return;
    emit(current.copyWith(selectedCardId: id));
  }
}
