import 'package:my_office/features/sales_points/data/data_source/sales_point_fb_data_source.dart';
import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';

import '../model/sales_point_drop_down_model.dart';

class SalesPointRepoImpl implements SalesPointRepository {
  final SalesPointFbDataSource salesPointFbDataSource;

  SalesPointRepoImpl(this.salesPointFbDataSource);

  @override
  Future<Map<String, dynamic>> getProductDetails(String productName) async {
    var snapshot = await salesPointFbDataSource.getInventory();
    Map<String, dynamic> productDetails = {};

    for (var a in snapshot.snapshot.children) {
      var data = a.value as Map<dynamic, dynamic>;
      if (data['name'].toString().toUpperCase() == productName.toUpperCase()) {
        productDetails = {
          'max_price': data['max_price'],
          'min_price': data['min_price'],
          'obc': data['obc'],
        };
        break;
      }
    }
    return productDetails;
  }

  @override
  Future<List<DropDownValueModel>> getProducts() async {
    var snapshot = await salesPointFbDataSource.getInventory();
    List<DropDownValueModel> products = [];
    int count = 1;

    for (var a in snapshot.snapshot.children) {
      var data = a.value as Map<dynamic, dynamic>;
      products.add(DropDownValueModel(name: data['name'], value: count));
      count++;
    }
    return products;
  }
}
