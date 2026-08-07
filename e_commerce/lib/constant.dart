import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

const String kBaseUrl = "http://10.0.2.2:5000/api";
const String kGetAllGategories = "$kBaseUrl/category";
const String kGetAllProducts = "$kBaseUrl/product";
const String kGetProductByCategory = "$kBaseUrl/category";
const String kGetNewProductByCategory = "$kBaseUrl/product";
const String kGetBestSellerProductByCategory = "$kBaseUrl/product";
// // Categoty
// POST /http://localhost:5000/api/category
// GET  /http://localhost:5000/api/category
// GET  /http://localhost:5000/api/category/:id
// PATCH  /http://localhost:5000/api/category/:id
// DELETE  /http://localhost:5000/api/category:id

// // Order
// POST /http://localhost:5000/api/order
// GET  /http://localhost:5000/api/order
// GET  /http://localhost:5000/api/order/:id
// PATCH  /http://localhost:5000/api/order/:id
// DELETE  /http://localhost:5000/api/order:id

// // Product
// POST /http://localhost:5000/api/product
// GET  /http://localhost:5000/api/product
// GET  /http://localhost:5000/api/product/:id
// GET /http://localhost:5000/api/category/:categoryId/product
// PATCH  /http://localhost:5000/api/product/:id
// DELETE  /http://localhost:5000/api/product:id

List<ProductEntity> kFakeProducts = [
  ProductEntity(
    id: '',
    name: '',
    thumbnailUrl: '',
    price: 0,
    rating: 0,
    stock: 0,
    soldCount: 0,
    ratingsQuantity: 0,
    category: CategoryEntity(id: '', name: '', imageUrl: ''),
  ),
];

List<CategoryEntity> kCategories = [
  CategoryEntity(id: '', name: '', imageUrl: ''),
];
