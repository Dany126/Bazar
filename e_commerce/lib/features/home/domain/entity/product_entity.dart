class ProductEntity {
  final int id;
  final String name;
  final double price;
  final String image;
  bool isFavorite = false;

  ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}
