class Product {
  final String name;

  Product({required this.name});

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      name: map['name'],
    );
  }
}

class ProductDetails {
  final String name;
  final String maxPrice;
  final String minPrice;
  final String obcPrice;

  ProductDetails({required this.name, required this.maxPrice, required this.minPrice, required this.obcPrice});

  factory ProductDetails.fromMap(Map<dynamic, dynamic> map) {
    return ProductDetails(
      name: map['name'],
      maxPrice: map['max_price'],
      minPrice: map['min_price'],
      obcPrice: map['obc'],
    );
  }
}
