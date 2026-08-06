import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/usecases/get_all_categories_usecase.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  GetCategoriesCubit({required this.getAllCategoriesUseCase})
    : super(GetCategoriesInitial());

  final GetAllCategoriesUseCase getAllCategoriesUseCase;

  Future<Either<Failure, List<CategoryEntity>>> fetchAllCategories() async {
    emit(GetCategoriesLoading());
    try {
      final Either<Failure, List<CategoryEntity>> result =
          await getAllCategoriesUseCase.call();
      result.fold(
        (failure) => emit(GetCategoriesFailure(failure.toString())),
        (categories) => emit(GetCategoriesSuccess(categories)),
      );
      return result;
    } catch (e) {
      emit(GetCategoriesFailure(e.toString()));
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
