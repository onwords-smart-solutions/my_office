
import '../entity/food_count_entity.dart';

abstract class FoodCountRepository {
  Future<List<FoodCountEntity>> getAllFoodCount(String month);
}
