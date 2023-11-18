import 'package:firebase_database/firebase_database.dart';

abstract class InvoiceGeneratorFbDataSource{
  Future<DatabaseEvent> getInventory();
}