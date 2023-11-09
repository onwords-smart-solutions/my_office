
import 'package:my_office/features/food_count/domain/entity/food_count_entity.dart';

import '../repository/food_count_repository.dart';

class GetAllFoodCountCase {
  final FoodCountRepository foodCountRepository;

  GetAllFoodCountCase({required this.foodCountRepository});

  Future<List<FoodCountEntity>> execute(String month) async {
    return foodCountRepository.getAllFoodCount(month);
  }
}
