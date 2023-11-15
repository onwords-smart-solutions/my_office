import 'package:firebase_database/firebase_database.dart';

abstract class SalesPointFbDataSource{
  Future<DatabaseEvent> getInventory();

}