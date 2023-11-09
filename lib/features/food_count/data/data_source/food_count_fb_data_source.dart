
import 'package:firebase_database/firebase_database.dart';

abstract class FoodCountFbDataSource {
  Future<DataSnapshot> getStaff();
  Future<DataSnapshot> getRefreshments();
}
