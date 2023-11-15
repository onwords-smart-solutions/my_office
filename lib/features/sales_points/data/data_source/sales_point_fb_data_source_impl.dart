import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/sales_points/data/data_source/sales_point_fb_data_source.dart';

class SalesPointFbDataSourceImpl implements SalesPointFbDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<DatabaseEvent> getInventory() {
    return ref.child('inventory_management').once();
  }

}