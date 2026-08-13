import 'package:equatable/equatable.dart';

enum SortOption { recommended, newest, lowestPrice, highestPrice }

enum GenderOption { men, women, kids }

enum DealsOption { onSale, freeShippingEligible }

class SearchFilterEntity extends Equatable {
  final SortOption sortBy;
  final GenderOption? gender;
  final DealsOption? deals;
  final double? minPrice;
  final double? maxPrice;

  const SearchFilterEntity({
    this.sortBy = SortOption.recommended,
    this.gender,
    this.deals,
    this.minPrice,
    this.maxPrice,
  });

  int get activeFilterCount {
    var count = 0;
    if (sortBy != SortOption.recommended) count++;
    if (gender != null) count++;
    if (deals != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    return count;
  }

  SearchFilterEntity copyWith({
    SortOption? sortBy,
    GenderOption? gender,
    bool clearGender = false,
    DealsOption? deals,
    bool clearDeals = false,
    double? minPrice,
    double? maxPrice,
    bool clearPrice = false,
  }) {
    return SearchFilterEntity(
      sortBy: sortBy ?? this.sortBy,
      gender: clearGender ? null : (gender ?? this.gender),
      deals: clearDeals ? null : (deals ?? this.deals),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  @override
  List<Object?> get props => [sortBy, gender, deals, minPrice, maxPrice];
}
