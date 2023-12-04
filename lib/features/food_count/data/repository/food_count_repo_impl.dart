import 'package:my_office/features/food_count/data/model/food_count_model.dart';

import '../../domain/repository/food_count_repository.dart';
import '../data_source/food_count_fb_data_source.dart';

class FoodCountRepoImpl implements FoodCountRepository {
  final FoodCountFbDataSource foodCountFbDataSource;

  FoodCountRepoImpl(this.foodCountFbDataSource);

  @override
  Future<List<FoodCountModel>> getAllFoodCounts(String month) async {
    return foodCountFbDataSource.getAllFoodCounts(month);
  }
}
