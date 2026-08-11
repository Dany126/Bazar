import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';

const String kBaseUrl = "http://10.0.2.2:5000/api";
const String kGetAllGategories = "$kBaseUrl/category";
const String kGetAllProducts = "$kBaseUrl/product";
const String kGetProductByCategory = "$kBaseUrl/category";
const String kGetNewProductByCategory = "$kBaseUrl/product";
const String kGetBestSellerProductByCategory = "$kBaseUrl/product";
const String kRefreshTokenUrl = "$kBaseUrl/user/refresh";
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

final List<OrderEntity> kOrders = [
  OrderEntity(
    id: 'ORD-100001',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_001',
          name: 'Wireless Headphones',
          thumbnailUrl: '',
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
          thumbnailUrl: '',
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

  OrderEntity(
    id: 'ORD-100002',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_003',
          name: 'Running Shoes',
          thumbnailUrl: '',
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
          thumbnailUrl: '',
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

  OrderEntity(
    id: 'ORD-100003',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_005',
          name: 'Leather Backpack',
          thumbnailUrl: '',
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

  OrderEntity(
    id: 'ORD-100004',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_006',
          name: 'Cotton Hoodie',
          thumbnailUrl: '',
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
          thumbnailUrl: '',
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

  OrderEntity(
    id: 'ORD-100005',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_008',
          name: 'Mechanical Keyboard',
          thumbnailUrl: '',
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

  OrderEntity(
    id: 'ORD-100006',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_009',
          name: 'Coffee Maker',
          thumbnailUrl: '',
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
          thumbnailUrl: '',
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

  OrderEntity(
    id: 'ORD-100007',
    user: 'user_1',
    products: [
      OrderProductEntity(
        product: ProductEntity(
          id: 'prod_011',
          name: 'Sunglasses',
          thumbnailUrl: '',
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
