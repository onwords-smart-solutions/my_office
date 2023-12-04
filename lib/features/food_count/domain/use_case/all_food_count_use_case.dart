import 'package:my_office/features/food_count/data/model/food_count_model.dart';
import 'package:my_office/features/food_count/domain/repository/food_count_repository.dart';

class AllFoodCountCase{
  final FoodCountRepository foodCountRepository;

  AllFoodCountCase({required this.foodCountRepository});

  Future<List<FoodCountModel>> execute(String month) async{
    return foodCountRepository.getAllFoodCounts(month);
  }

}