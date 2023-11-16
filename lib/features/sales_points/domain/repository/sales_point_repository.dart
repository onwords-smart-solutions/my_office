import '../../data/model/sales_point_model.dart';

abstract class SalesPointRepository{

  Future<List<Product>> getProducts();
  Future<ProductDetails> getProductDetails(String productName) ;
}