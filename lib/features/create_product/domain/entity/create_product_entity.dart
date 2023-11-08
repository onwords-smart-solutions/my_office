
class CreateProductEntity {
  final String id;
  final String name;
  final String maxPrice;
  final String minPrice;
  final String obc;
  final String stock;

  CreateProductEntity({
    required this.id,
    required this.name,
    required this.maxPrice,
    required this.minPrice,
    required this.obc,
    required this.stock,
  });
}
