
import 'package:flutter/material.dart';
import 'package:my_office/features/food_count/domain/use_case/all_food_count_use_case.dart';
import 'package:my_office/features/food_count/domain/use_case/food_count_staff_names_use_case.dart';

import '../../data/model/food_count_model.dart';

class FoodCountProvider with ChangeNotifier {
  final AllFoodCountCase _allFoodCountCase;
  final AllFoodCountStaffNamesCase _allFoodCountStaffNamesCase;

  FoodCountProvider(this._allFoodCountCase, this._allFoodCountStaffNamesCase);

  Future<Map<String, FoodCountModel>> fetchAllFoodCount() async{
    return _allFoodCountCase.execute();
  }

  Future<List<dynamic>> fetchFoodCountByStaffName(String staffName) async{
    return _allFoodCountStaffNamesCase.execute(staffName);
  }
}
