import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit({required this.getAllProductsUseCase})
    : super(GetProductsInitial());
  final GetAllProductsUseCase getAllProductsUseCase;

  Future<Either<Failure, List<ProductEntity>>> fetchAllProducts({
    required int page,
    required int limit,
  }) async {
    emit(GetProductsLoading());
    try {
      final result = await getAllProductsUseCase.call(page: page, limit: limit);
      result.fold(
        (failure) => emit(GetProductsFailure(message: failure.toString())),
        (products) => emit(GetProductsSuccess(products: products)),
      );
      return result;
    } catch (e) {
      emit(GetProductsFailure(message: e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
