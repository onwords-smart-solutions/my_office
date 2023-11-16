import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/sales_points/data/data_source/sales_point_fb_data_source.dart';
import 'package:my_office/features/sales_points/data/model/sales_point_model.dart';
import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';

class SalesPointRepoImpl implements SalesPointRepository {
  final SalesPointFbDataSource salesPointFbDataSource;

  SalesPointRepoImpl(this.salesPointFbDataSource);

  @override
  Future<ProductDetails> getProductDetails(String productName) async {
    final DatabaseEvent event = await salesPointFbDataSource.getInventory();
    for (var child in event.snapshot.children) {
      var value = child.value as Map<dynamic, dynamic>;
      if (value['name'].toString().toUpperCase() == productName.toUpperCase()) {
        return ProductDetails.fromMap(value);
      }
    }
    throw Exception("Product not found");
  }

  @override
  Future<List<Product>> getProducts() async {
    final DatabaseEvent event = await salesPointFbDataSource.getInventory();
    return event.snapshot.children.map((child) {
      var value = child.value as Map<dynamic, dynamic>;
      return Product.fromMap(value);
    }).toList();
  }

}
