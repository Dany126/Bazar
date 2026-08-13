import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/search/presentation/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController _controller;
  final FocusNode _focusNode;

  const CustomSearchTextField({
    super.key,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) : _controller = controller,
       _focusNode = focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,

      textInputAction: TextInputAction.search,
      style: AppStyles.textStylesRegular12(context),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.kSecondaryAccentColor.withAlpha(40),
        hintText: 'Search',
        hintStyle: AppStyles.textStylesRegular12(context),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            Assets.assetsImagesSearchIcon,
            width: 20,
            height: 20,
          ),
        ),

        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                _controller.clear();
                context.read<SearchCubit>().clearSearch();
              },
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: context.read<SearchCubit>().onQueryChanged,
      onSubmitted: context.read<SearchCubit>().submitQuery,
    );
  }
}
