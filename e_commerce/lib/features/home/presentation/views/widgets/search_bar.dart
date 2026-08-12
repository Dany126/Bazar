
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.isSearch,
    this.onTap,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final bool isSearch;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _hasText = widget.controller?.text.isNotEmpty ?? false;

    widget.controller?.addListener(_controllerListener);
  }

  void _controllerListener() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;

    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: widget.isSearch,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,

      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,

      decoration: InputDecoration(
        filled: true,

        fillColor:
            AppColors.kSecondaryAccentColor.withAlpha(40),

        hintText: 'Search',
        hintStyle:
            AppStyles.textStylesRegular12(context),

        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            Assets.assetsImagesSearchIcon,
            width: 20,
            height: 20,
          ),
        ),

        suffixIcon: _hasText
            ? IconButton(
                onPressed: () {
                  widget.controller?.clear();
                  widget.onClear?.call();
                },
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ),
              )
            : null,

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
    );
  }
}

