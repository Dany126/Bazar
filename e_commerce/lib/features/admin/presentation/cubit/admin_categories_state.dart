import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

abstract class AdminCategoriesState {
  const AdminCategoriesState();
}

class AdminCategoriesInitial extends AdminCategoriesState {
  const AdminCategoriesInitial();
}

class AdminCategoriesLoading extends AdminCategoriesState {
  const AdminCategoriesLoading();
}

class AdminCategoriesLoaded extends AdminCategoriesState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  final String? selectedCategoryId;
  final String? selectedCategoryName;

  const AdminCategoriesLoaded({
    required this.categories,
    required this.products,
    this.selectedCategoryId,
    this.selectedCategoryName,
  });

  /// Products displayed in the right side.
  ///
  /// If no category is selected -> show all products.
  /// If a category is selected -> show only products
  /// belonging to that category.
  List<ProductModel> get displayedProducts {
    if (selectedCategoryId == null) {
      return products;
    }

    return products.where((product) {
      return product.category.id == selectedCategoryId;
    }).toList();
  }

  /// Number of products belonging to a category.
  int productCountForCategory(String categoryId) {
    return products.where((product) {
      return product.category.id == categoryId;
    }).length;
  }

  AdminCategoriesLoaded copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    String? selectedCategoryId,
    String? selectedCategoryName,
    bool clearSelection = false,
  }) {
    return AdminCategoriesLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: clearSelection
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryName: clearSelection
          ? null
          : selectedCategoryName ?? this.selectedCategoryName,
    );
  }
}

class AdminCategoriesError extends AdminCategoriesState {
  final String message;

  const AdminCategoriesError(this.message);
}
