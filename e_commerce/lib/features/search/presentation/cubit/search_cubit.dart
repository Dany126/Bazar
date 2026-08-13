import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';
import 'package:e_commerce/features/search/domain/use_case/search_products_use_case.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchProductsUsecase searchProductsUsecase;
  Timer? _debounce;

  String _currentQuery = '';
  SearchFilterEntity _currentFilter = const SearchFilterEntity();

  SearchCubit(this.searchProductsUsecase) : super(const SearchInitial());

  /// Call on every keystroke in the search field. Debounces network calls.
  void onQueryChanged(String query) {
    _debounce?.cancel();
    _currentQuery = query.trim();

    if (_currentQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(_currentQuery, _currentFilter);
    });
  }

  /// Call on keyboard search-action submit to skip the debounce delay.
  Future<void> submitQuery(String query) async {
    _debounce?.cancel();
    _currentQuery = query.trim();
    if (_currentQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }
    await _search(_currentQuery, _currentFilter);
  }

  Future<void> applyFilter(SearchFilterEntity filter) async {
    _currentFilter = filter;
    if (_currentQuery.isNotEmpty) {
      await _search(_currentQuery, filter);
    }
  }

  void clearSearch() {
    _debounce?.cancel();
    _currentQuery = '';
    _currentFilter = const SearchFilterEntity();
    emit(const SearchInitial());
  }

  Future<void> _search(String query, SearchFilterEntity filter) async {
    emit(const SearchLoading());

    final result = await searchProductsUsecase(
      SearchProductsParams(query: query, filter: filter),
    );

    result.fold(
      (failure) =>
          emit(SearchFailure(failure.message)), // adjust to your Failure shape
      (products) {
        if (products.isEmpty) {
          emit(SearchNoResults(query));
        } else {
          emit(SearchSuccess(query: query, products: products, filter: filter));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
