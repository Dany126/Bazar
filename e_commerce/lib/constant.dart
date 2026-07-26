import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

const String kBaseUrl = "http://10.0.2.2:5000/api";

final List<ProductEntity> kDumyProducts = [
  ProductEntity(
    id: 1,
    name: "Men's Harrington Jacket",
    price: 148.00,
    thumbnailUrl: Assets.assetsImagesD1,

    rating: 0,
    soldCount: 0,
  ),
  ProductEntity(
    id: 2,
    name: "Women's Puffer Vest",
    price: 89.00,
    thumbnailUrl: Assets.assetsImagesD2,
    rating: 0,
    soldCount: 0,
  ),
  ProductEntity(
    id: 3,
    name: "Classic Jacket",
    price: 120.00,
    thumbnailUrl: Assets.assetsImagesD1,
    rating: 0,
    soldCount: 0,
  ),
  ProductEntity(
    id: 4,
    name: "Puffer Vest",
    price: 99.00,
    thumbnailUrl: Assets.assetsImagesD2,
    rating: 0,
    soldCount: 0,
  ),
];
