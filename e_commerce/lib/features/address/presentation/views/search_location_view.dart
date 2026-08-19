import 'dart:developer';

import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchLocationView extends StatefulWidget {
  const SearchLocationView({super.key});

  @override
  State<SearchLocationView> createState() => _SearchLocationViewState();
}

class _SearchLocationViewState extends State<SearchLocationView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search for a place or address',
            border: InputBorder.none,
          ),
          onChanged: (query) =>
              context.read<AddressCubit>().searchPlaces(query),
        ),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressSearchLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    const _SearchResultSkeletonTile(),
              ),
            );
          }

          if (state is AddressSearchError) {
            log(state.message);
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is AddressSearchLoaded) {
            if (state.results.isEmpty) {
              return const Center(
                child: Text(
                  'No results',
                  style: TextStyle(color: Colors.black45),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final result = state.results[index];
                return ListTile(
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    result.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    context.read<AddressCubit>().selectSearchResult(result);
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          }

          return const Center(
            child: Text(
              'Start typing to search',
              style: TextStyle(color: Colors.black45),
            ),
          );
        },
      ),
    );
  }
}

class _SearchResultSkeletonTile extends StatelessWidget {
  const _SearchResultSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.location_on_outlined),
      title: Text('Placeholder result name goes here'),
    );
  }
}
