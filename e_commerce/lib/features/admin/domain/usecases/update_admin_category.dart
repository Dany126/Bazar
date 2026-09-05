import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_category_repository.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateAdminCategoryUseCase {
  final AdminCategoriesRepository repository;

  const UpdateAdminCategoryUseCase({required this.repository});

  Future<Either<Failure, CategoryModel>> call({
    required String id,
    required String name,
    XFile? image,
  }) {
    return repository.updateCategory(id: id, name: name, image: image);
  }
}
