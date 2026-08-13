part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Nothing typed yet — show "Shop by Categories".
class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchSuccess extends SearchState {
  final String query;
  final List<ProductEntity> products;
  final SearchFilterEntity filter;

  const SearchSuccess({
    required this.query,
    required this.products,
    required this.filter,
  });

  SearchSuccess copyWith({
    String? query,
    List<ProductEntity>? products,
    SearchFilterEntity? filter,
  }) {
    return SearchSuccess(
      query: query ?? this.query,
      products: products ?? this.products,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [query, products, filter];
}

/// Query returned zero products — "Sorry, we couldn't find any matching
/// result for your Search".
class SearchNoResults extends SearchState {
  final String query;

  const SearchNoResults(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
