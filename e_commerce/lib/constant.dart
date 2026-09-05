import 'package:flutter/foundation.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';

/// ===============================================================
/// API CONFIGURATION
/// ===============================================================

const String kBaseUrl = kIsWeb
    ? 'http://localhost:5000/api'
    : 'http://192.168.1.2:5000/api';

const String kGetAllGategories = '$kBaseUrl/category';
const String kGetAllProducts = '$kBaseUrl/product';
const String kGetProductByCategory = '$kBaseUrl/category';
const String kGetNewProductByCategory = '$kBaseUrl/product';
const String kGetBestSellerProductByCategory = '$kBaseUrl/product';
const String kRefreshTokenUrl = '$kBaseUrl/user/refresh';

/// ===============================================================
/// CATEGORY ENDPOINTS
/// ===============================================================
///
/// POST   /api/category
/// GET    /api/category
/// GET    /api/category/:id
/// PATCH  /api/category/:id
/// DELETE /api/category/:id
///
/// ===============================================================
/// ORDER ENDPOINTS
/// ===============================================================
///
/// POST   /api/order
/// GET    /api/order
/// GET    /api/order/:id
/// PATCH  /api/order/:id
/// DELETE /api/order/:id
///
/// ===============================================================
/// PRODUCT ENDPOINTS
/// ===============================================================
///
/// POST   /api/product
/// GET    /api/product
/// GET    /api/product/:id
/// GET    /api/category/:categoryId/product
/// PATCH  /api/product/:id
/// DELETE /api/product/:id
///
/// ===============================================================
/// FAKE PRODUCT DATA
/// ===============================================================
///
/// Used only while products are loading, for Skeletonizer.
/// IMPORTANT:
/// Do NOT use:
///     [] as List<String>
///
/// Use:
///     <String>[]
///
/// because [] is initially List<dynamic>.
///

final List<ProductEntity> kFakeProducts = [
  ProductEntity(
    id: '',
    name: '',
    images: <String>[],
    price: 0,
    rating: 0,
    stock: 0,
    soldCount: 0,
    ratingsQuantity: 0,
    category: CategoryEntity(id: '', name: '', imageUrl: ''),
  ),
];

/// ===============================================================
/// FAKE CATEGORY DATA
/// ===============================================================
///
/// Used for loading/skeleton states if needed.
///

final List<CategoryEntity> kCategories = [
  CategoryEntity(id: '', name: '', imageUrl: ''),
];

/// ===============================================================
/// FAKE ORDERS
/// ===============================================================
///
/// Used by UI/demo screens that still depend on local order data.
///

final List<OrderEntity> kOrders = [
  // =============================================================
  // ORDER 1
  // =============================================================

  OrderEntity(
    id: 'ORD-100001',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_001',
          name: 'Wireless Headphones',
          images: <String>[],
          price: 75.0,
          rating: 4.7,
          stock: 35,
          soldCount: 120,
          ratingsQuantity: 48,
          category: CategoryEntity(
            id: 'cat_001',
            name: 'Electronics',
            imageUrl: '',
          ),
        ),
        quantity: 2,
        price: 75.0,
      ),

      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_002',
          name: 'Smart Watch',
          images: <String>[],
          price: 50.0,
          rating: 4.5,
          stock: 20,
          soldCount: 85,
          ratingsQuantity: 31,
          category: CategoryEntity(
            id: 'cat_001',
            name: 'Electronics',
            imageUrl: '',
          ),
        ),
        quantity: 1,
        price: 50.0,
      ),
    ],
    totalPrice: 200.0,
    paymentMethod: 'card',
    paymentStatus: 'paid',
    orderStatus: 'processing',
  ),

  // =============================================================
  // ORDER 2
  // =============================================================
  OrderEntity(
    id: 'ORD-100002',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_003',
          name: 'Running Shoes',
          images: <String>[],
          price: 80.0,
          rating: 4.8,
          stock: 15,
          soldCount: 210,
          ratingsQuantity: 76,
          category: CategoryEntity(id: 'cat_002', name: 'Shoes', imageUrl: ''),
        ),
        quantity: 1,
        price: 80.0,
      ),

      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_004',
          name: 'Sports T-Shirt',
          images: <String>[],
          price: 35.0,
          rating: 4.4,
          stock: 40,
          soldCount: 150,
          ratingsQuantity: 54,
          category: CategoryEntity(
            id: 'cat_003',
            name: 'Clothing',
            imageUrl: '',
          ),
        ),
        quantity: 2,
        price: 35.0,
      ),
    ],
    totalPrice: 150.0,
    paymentMethod: 'cash',
    paymentStatus: 'pending',
    orderStatus: 'confirmed',
  ),

  // =============================================================
  // ORDER 3
  // =============================================================
  OrderEntity(
    id: 'ORD-100003',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_005',
          name: 'Leather Backpack',
          images: <String>[],
          price: 95.0,
          rating: 4.6,
          stock: 18,
          soldCount: 92,
          ratingsQuantity: 37,
          category: CategoryEntity(id: 'cat_004', name: 'Bags', imageUrl: ''),
        ),
        quantity: 1,
        price: 95.0,
      ),
    ],
    totalPrice: 95.0,
    paymentMethod: 'card',
    paymentStatus: 'paid',
    orderStatus: 'shipped',
  ),

  // =============================================================
  // ORDER 4
  // =============================================================
  OrderEntity(
    id: 'ORD-100004',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_006',
          name: 'Cotton Hoodie',
          images: <String>[],
          price: 60.0,
          rating: 4.3,
          stock: 25,
          soldCount: 134,
          ratingsQuantity: 42,
          category: CategoryEntity(
            id: 'cat_003',
            name: 'Clothing',
            imageUrl: '',
          ),
        ),
        quantity: 1,
        price: 60.0,
      ),

      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_007',
          name: 'Baseball Cap',
          images: <String>[],
          price: 20.0,
          rating: 4.2,
          stock: 50,
          soldCount: 200,
          ratingsQuantity: 65,
          category: CategoryEntity(
            id: 'cat_003',
            name: 'Clothing',
            imageUrl: '',
          ),
        ),
        quantity: 2,
        price: 20.0,
      ),
    ],
    totalPrice: 100.0,
    paymentMethod: 'cash',
    paymentStatus: 'paid',
    orderStatus: 'delivered',
  ),

  // =============================================================
  // ORDER 5
  // =============================================================
  OrderEntity(
    id: 'ORD-100005',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_008',
          name: 'Mechanical Keyboard',
          images: <String>[],
          price: 120.0,
          rating: 4.9,
          stock: 12,
          soldCount: 74,
          ratingsQuantity: 29,
          category: CategoryEntity(
            id: 'cat_001',
            name: 'Electronics',
            imageUrl: '',
          ),
        ),
        quantity: 1,
        price: 120.0,
      ),
    ],
    totalPrice: 120.0,
    paymentMethod: 'card',
    paymentStatus: 'failed',
    orderStatus: 'cancelled',
  ),

  // =============================================================
  // ORDER 6
  // =============================================================
  OrderEntity(
    id: 'ORD-100006',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_009',
          name: 'Coffee Maker',
          images: <String>[],
          price: 110.0,
          rating: 4.5,
          stock: 10,
          soldCount: 56,
          ratingsQuantity: 23,
          category: CategoryEntity(
            id: 'cat_005',
            name: 'Home Appliances',
            imageUrl: '',
          ),
        ),
        quantity: 1,
        price: 110.0,
      ),

      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_010',
          name: 'Coffee Mug',
          images: <String>[],
          price: 15.0,
          rating: 4.1,
          stock: 100,
          soldCount: 320,
          ratingsQuantity: 88,
          category: CategoryEntity(
            id: 'cat_006',
            name: 'Kitchen',
            imageUrl: '',
          ),
        ),
        quantity: 2,
        price: 15.0,
      ),
    ],
    totalPrice: 140.0,
    paymentMethod: 'card',
    paymentStatus: 'paid',
    orderStatus: 'delivered',
  ),

  // =============================================================
  // ORDER 7
  // =============================================================
  OrderEntity(
    id: 'ORD-100007',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_011',
          name: 'Sunglasses',
          images: <String>[],
          price: 45.0,
          rating: 4.4,
          stock: 30,
          soldCount: 180,
          ratingsQuantity: 61,
          category: CategoryEntity(
            id: 'cat_007',
            name: 'Accessories',
            imageUrl: '',
          ),
        ),
        quantity: 1,
        price: 45.0,
      ),
    ],
    totalPrice: 45.0,
    paymentMethod: 'cash',
    paymentStatus: 'pending',
    orderStatus: 'pending',
  ),
];

/// ===============================================================
/// ADMIN CREDENTIALS
/// ===============================================================
///
/// ADMIN@gmail.com
/// Admin123!
