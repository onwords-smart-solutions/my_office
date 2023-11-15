import '../../data/model/sales_point_drop_down_model.dart';

abstract class SalesPointRepository{

  Future<List<DropDownValueModel>> getProducts();
  Future<Map<String, dynamic>> getProductDetails(String productName);
}