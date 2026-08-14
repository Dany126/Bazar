// lib/features/payment_method/presenation/modelview/cubit/payment_method_cubit.dart
import 'package:e_commerce/features/payment_method/domain/use_case/add_payment_method_use_case.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/delete_payment_method_use_case.dart';
import 'package:e_commerce/features/payment_method/domain/use_case/get_payment_methods_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_method_state.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;
  final AddPaymentMethodUseCase addPaymentMethodUseCase;
  final DeletePaymentMethodUseCase deletePaymentMethodUseCase;

  PaymentMethodCubit({
    required this.getPaymentMethodsUseCase,
    required this.addPaymentMethodUseCase,
    required this.deletePaymentMethodUseCase,
  }) : super(PaymentMethodInitial());

  Future<void> getPaymentMethods() async {
    emit(PaymentMethodLoading());
    final result = await getPaymentMethodsUseCase();
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (methods) => emit(PaymentMethodLoaded(methods)),
    );
  }

  Future<void> addPaymentMethod({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    emit(PaymentMethodLoading());
    final result = await addPaymentMethodUseCase(
      cardholderName: cardholderName,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (_) => getPaymentMethods(),
    );
  }

  Future<void> deletePaymentMethod({required String paymentMethodId}) async {
    final result = await deletePaymentMethodUseCase(
      paymentMethodId: paymentMethodId,
    );
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (_) => getPaymentMethods(),
    );
  }
}
