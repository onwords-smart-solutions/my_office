
import '../../data/model/food_count_model.dart';

abstract class FoodCountRepository {
  Future<List<FoodCountModel>> getAllFoodCounts();
}
