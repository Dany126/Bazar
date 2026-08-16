import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:e_commerce/features/address/presentation/views/widgets/add_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                if (state is AddressLoading || state is AddressInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AddressError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final addresses = (state as AddressLoaded).addresses;

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
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _AddressCard(address: addresses[index]),
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
                      child: const AddAddressView(),
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

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final AddressEntity address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${address.street}, ${address.city}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20, color: Colors.black45),
            onSelected: (value) {
              if (value == 'delete') {
                context.read<AddressCubit>().deleteAddress(address.id);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
