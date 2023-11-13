
import 'package:my_office/features/food_count/data/model/food_count_model.dart';

abstract class FoodCountFbDataSource {
  Future<List<FoodCountModel>>getAllFoodCounts();

  Future<List<dynamic>> getFoodCountByStaffName(String staffName);
}
