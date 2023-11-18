import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source.dart';

class InvoiceGeneratorFbDataSourceImpl implements InvoiceGeneratorFbDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<DatabaseEvent> getInventory() {
    return ref.child('inventory_management').once();
  }
}