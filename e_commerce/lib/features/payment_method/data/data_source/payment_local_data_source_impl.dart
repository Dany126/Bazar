import '../../domain/entity/saved_card_entity.dart';
import '../model/saved_card_model.dart';

/// Holds saved cards purely in memory for the current app session.
///
/// This is a drop-in stand-in for a remote data source. When the backend
/// is ready, write a `PaymentRemoteDataSource` with the same method
/// signatures (backed by Dio, hitting your friend's Node.js API /
/// Paymob), and swap it into `PaymentRepoImpl` — nothing above the data
/// layer needs to change.
class PaymentLocalDataSource {
  final List<SavedCardModel> _cards = [];

  Future<List<SavedCardModel>> getSavedCards() async =>
      List.unmodifiable(_cards);

  Future<SavedCardModel> addCard({
    required String cardNumber,
    required String ccv,
    required String expiry,
    required String cardholderName,
  }) async {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    final model = SavedCardModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      last4: digits.substring(digits.length - 4),
      brand: detectCardBrand(digits),
      cardholderName: cardholderName.trim(),
      expiry: expiry.trim(),
    );
    _cards.add(model);
    return model;
  }

  Future<void> removeCard(String id) async {
    _cards.removeWhere((c) => c.id == id);
  }
}
