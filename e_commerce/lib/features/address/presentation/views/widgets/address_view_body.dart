import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:e_commerce/features/address/presentation/views/map_view.dart';
import 'package:e_commerce/features/address/presentation/views/widgets/address_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

const kAddressAccentColor = Color(0xFF7B61FF);

class AddressViewBody extends StatelessWidget {
  const AddressViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildHeader(context),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state is AddressLoading ||
                    state is AddressInitial ||
                    state is AddressLocating ||
                    state is AddressResolving) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          const AddressCardSkeleton(),
                    ),
                  );
                }
                if (state is AddressError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is! AddressListLoaded) {
                  return const SizedBox.shrink();
                }

                final addresses = state.addresses;

                if (addresses.isEmpty) {
                  return const Center(
                    child: Text(
                      'No saved addresses yet',
                      style: TextStyle(color: Colors.black45),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: addresses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      AddressCard(address: addresses[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(21),
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Address',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AddressCubit>(),
                      child: const MapView(),
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
                child: const Icon(Icons.add, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
