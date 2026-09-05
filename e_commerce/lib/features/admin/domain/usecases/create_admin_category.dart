import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_category_repository.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdminCategoryUseCase {
  final AdminCategoriesRepository repository;

  const CreateAdminCategoryUseCase({required this.repository});

  Future<Either<Failure, CategoryModel>> call({
    required String name,
    required XFile image,
  }) {
    return repository.createCategory(name: name, image: image);
  }
}
