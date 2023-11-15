import 'package:firebase_database/firebase_database.dart';

abstract class RefreshmentFbDataSource {
  Future<DataSnapshot> getRefreshmentData({required String date, required String mode});

  Future<DataSnapshot> getFoodData({required String date});

  Future<DataSnapshot> getRefreshmentDetails({required String date, required String mode});
  Future<DataSnapshot> getFoodDetails({required String date});
  Future<void> updateRefreshmentCount(
      {required String name, required String date, required String mode, required String item, required int count,});
  Future<void> updateFoodCount({required String name, required String date, required int foodCount});

}
