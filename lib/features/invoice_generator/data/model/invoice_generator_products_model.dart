class InvoiceGeneratorProducts {
  final String name;

  InvoiceGeneratorProducts({required this.name});

  factory InvoiceGeneratorProducts.fromMap(Map<dynamic, dynamic> map) {
    return InvoiceGeneratorProducts(
      name: map['name'],
    );
  }
}

class InvoiceGeneratorProductDetails {
  final String name;
  final String maxPrice;
  final String minPrice;
  final String obcPrice;

  InvoiceGeneratorProductDetails({required this.name, required this.maxPrice, required this.minPrice, required this.obcPrice});

  factory InvoiceGeneratorProductDetails.fromMap(Map<dynamic, dynamic> map) {
    return InvoiceGeneratorProductDetails(
      name: map['name'],
      maxPrice: map['max_price'],
      minPrice: map['min_price'],
      obcPrice: map['obc'],
    );
  }
}
