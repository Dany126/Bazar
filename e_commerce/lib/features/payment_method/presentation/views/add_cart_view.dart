import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_cubit.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Matches the "Add Card" screen from the design. Submits into
/// [PaymentCubit] -> [AddCardUseCase] -> [PaymentRepoImpl], which
/// validates and stores the card in the local data source — no
/// backend/Paymob call happens yet.
class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final _cardNumberController = TextEditingController();
  final _ccvController = TextEditingController();
  final _expController = TextEditingController();
  final _cardholderController = TextEditingController();

  int _cardCountBeforeSubmit = 0;

  static const _fieldFill = Color(0xFFEDEDED);
  static const _purple = Color(0xFF7C6FE0);

  @override
  void dispose() {
    _cardNumberController.dispose();
    _ccvController.dispose();
    _expController.dispose();
    _cardholderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is PaymentLoaded &&
            state.cards.length > _cardCountBeforeSubmit) {
          // A card was added successfully — go back to the list.
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Add Card',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _RoundedField(
                  controller: _cardNumberController,
                  hint: 'Card Number',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _RoundedField(
                        controller: _ccvController,
                        hint: 'CCV',
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _RoundedField(
                        controller: _expController,
                        hint: 'Exp (MM/YY)',
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _RoundedField(
                  controller: _cardholderController,
                  hint: 'Cardholder Name',
                  keyboardType: TextInputType.name,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _onSave,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final cubit = context.read<PaymentCubit>();
    final current = cubit.state;
    _cardCountBeforeSubmit = current is PaymentLoaded
        ? current.cards.length
        : 0;

    cubit.addCard(
      cardNumber: _cardNumberController.text,
      ccv: _ccvController.text,
      expiry: _expController.text,
      cardholderName: _cardholderController.text,
    );
  }
}

class _RoundedField extends StatelessWidget {
  const _RoundedField({
    required this.controller,
    required this.hint,
    required this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
        filled: true,
        fillColor: _AddCardViewState._fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
