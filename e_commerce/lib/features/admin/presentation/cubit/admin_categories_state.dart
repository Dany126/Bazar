import 'package:e_commerce/features/home/data/models/category_model.dart';

abstract class AdminCategoriesState {
  const AdminCategoriesState();
}

class AdminCategoriesInitial extends AdminCategoriesState {
  const AdminCategoriesInitial();
}

class AdminCategoriesCreating extends AdminCategoriesState {
  const AdminCategoriesCreating();
}

class AdminCategoriesCreated extends AdminCategoriesState {
  final CategoryModel category;

  const AdminCategoriesCreated(this.category);
}

class AdminCategoriesDeleting extends AdminCategoriesState {
  final String categoryId;

  const AdminCategoriesDeleting(this.categoryId);
}

class AdminCategoriesDeleted extends AdminCategoriesState {
  final String categoryId;

  const AdminCategoriesDeleted(this.categoryId);
}

class AdminCategoriesFailure extends AdminCategoriesState {
  final String message;

  const AdminCategoriesFailure(this.message);
}
