import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_cubit.dart';
import 'package:e_commerce/features/payment_method/presentation/model_view/cubit/payment_state.dart';
import 'package:e_commerce/features/payment_method/presentation/views/add_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/saved_card_entity.dart';

/// Matches the "Payment" screen from the design, minus the PayPal section.
/// Loads cards through [PaymentCubit] -> [GetSavedCardsUseCase] on init;
/// the use case reads from the local data source, so nothing here calls
/// a backend.
class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({super.key});
  static const routeName = '/payment-methods';

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCubit>().loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Payment',
        actions: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<PaymentCubit>(),
                      child: const AddCardView(),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(21),
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.black87),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoading || state is PaymentInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ),
              );
            }
            if (state is PaymentError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.black54),
                ),
              );
            }

            final loaded = state as PaymentLoaded;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                if (loaded.cards.isEmpty)
                  const Center(
                    child: Text(
                      'No saved cards yet',
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  ),
                ...loaded.cards.map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CardTile(
                      card: card,
                      selected: card.id == loaded.selectedCardId,
                      onTap: () =>
                          context.read<PaymentCubit>().selectCard(card.id),
                      onRemove: () =>
                          context.read<PaymentCubit>().removeCard(card.id),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.selected,
    required this.onTap,
    required this.onRemove,
  });

  final SavedCardEntity card;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onRemove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.kCardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: AppColors.kPrimaryColor, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Text(
              '**** ${card.last4}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 10),
            if (card.brand == CardBrand.mastercard) const _MastercardIcon(),
            if (card.brand == CardBrand.visa) const _VisaLabel(),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppColors.kPrimaryColor,
                size: 20,
              )
            else
              const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

/// Small overlapping-circles mark, standing in for the Mastercard logo.
class _MastercardIcon extends StatelessWidget {
  const _MastercardIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 16,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisaLabel extends StatelessWidget {
  const _VisaLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'VISA',
      style: TextStyle(
        color: Color(0xFF1A1F71),
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}
