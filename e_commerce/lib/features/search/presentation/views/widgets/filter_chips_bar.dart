import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';
import 'package:flutter/material.dart';

import 'filter_bottom_sheet.dart';

final _sortOptions = [
  FilterOptionData('Recommended', 'recommended'),
  FilterOptionData('Newest', 'newest'),
  FilterOptionData('Lowest - Highest Price', 'lowestPrice'),
  FilterOptionData('Highest - Lowest Price', 'highestPrice'),
];

const _genderOptions = [
  FilterOptionData('Men', 'men'),
  FilterOptionData('Women', 'women'),
  FilterOptionData('Kids', 'kids'),
];

const _dealsOptions = [
  FilterOptionData('On sale', 'onSale'),
  FilterOptionData('Free Shipping Eligible', 'freeShippingEligible'),
];

class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  final SearchFilterEntity filter;
  final ValueChanged<SearchFilterEntity> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(
            context,
            label: 'Sort by',
            active: filter.sortBy != SortOption.recommended,
            onTap: () async {
              final value = await SingleSelectFilterSheet.show(
                context,
                title: 'Sort by',
                options: _sortOptions,
                initialValue: filter.sortBy.name,
              );
              if (value == null) {
                onFilterChanged(
                  filter.copyWith(sortBy: SortOption.recommended),
                );
              } else {
                onFilterChanged(
                  filter.copyWith(sortBy: SortOption.values.byName(value)),
                );
              }
            },
          ),
          const SizedBox(width: 10),
          _chip(
            context,
            label: 'Gender',
            active: filter.gender != null,
            onTap: () async {
              final value = await SingleSelectFilterSheet.show(
                context,
                title: 'Gender',
                options: _genderOptions,
                initialValue: filter.gender?.name,
              );
              onFilterChanged(
                value == null
                    ? filter.copyWith(clearGender: true)
                    : filter.copyWith(
                        gender: GenderOption.values.byName(value),
                      ),
              );
            },
          ),
          const SizedBox(width: 10),
          _chip(
            context,
            label: 'Deals',
            active: filter.deals != null,
            onTap: () async {
              final value = await SingleSelectFilterSheet.show(
                context,
                title: 'Deals',
                options: _dealsOptions,
                initialValue: filter.deals?.name,
              );
              onFilterChanged(
                value == null
                    ? filter.copyWith(clearDeals: true)
                    : filter.copyWith(deals: DealsOption.values.byName(value)),
              );
            },
          ),
          const SizedBox(width: 10),
          _chip(
            context,
            label: 'Price',
            active: filter.minPrice != null || filter.maxPrice != null,
            onTap: () async {
              final result = await PriceFilterSheet.show(
                context,
                initialMin: filter.minPrice,
                initialMax: filter.maxPrice,
              );
              if (result == null) return;
              onFilterChanged(
                result.min == null && result.max == null
                    ? filter.copyWith(clearPrice: true)
                    : filter.copyWith(
                        minPrice: result.min,
                        maxPrice: result.max,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.kPrimaryColor
              : AppColors.kCardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: active ? Colors.white : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
