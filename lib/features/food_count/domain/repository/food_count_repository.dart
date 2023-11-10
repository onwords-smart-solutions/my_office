
import '../../data/model/food_count_model.dart';

abstract class FoodCountRepository {
  Future<Map<String, FoodCountModel>> getAllFoodCounts();

  Future<List<dynamic>> getFoodCountByStaffName(String staffName);
}
