
import '../repository/food_count_repository.dart';

class AllFoodCountStaffNamesCase {
  final FoodCountRepository foodCountRepository;

  AllFoodCountStaffNamesCase({required this.foodCountRepository});

  Future<List<dynamic>> execute(String staffName) async{
    return await foodCountRepository.getFoodCountByStaffName(staffName);
  }

}
