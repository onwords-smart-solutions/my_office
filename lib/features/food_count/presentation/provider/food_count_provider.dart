
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/food_count_entity.dart';
import '../../domain/use_case/food_count_use_case.dart';

class FoodCountProvider with ChangeNotifier {
  final GetAllFoodCountCase getAllFoodCountUseCase;
  bool isLoading = false;
  String currentMonth = DateFormat.MMMM().format(DateTime.now());
  List<FoodCountEntity> allFoodCountList = [];

  FoodCountProvider(this.getAllFoodCountUseCase) {
    fetchAllFoodCount(currentMonth);
  }

  void setCurrentMonth(String month) {
    currentMonth = month;
    notifyListeners();
    fetchAllFoodCount(month);
  }

  Future<void> fetchAllFoodCount(String month) async {
    isLoading = true;

    try {
      allFoodCountList = await getAllFoodCountUseCase.execute(month);
    } catch (e) {
      'Failed to fetch data: ${e.toString()}';
    }

    isLoading = false;
    notifyListeners();
  }

  void refreshFoodCount() {
    fetchAllFoodCount(currentMonth);
  }

  FoodCountEntity? getFoodCountByName(String name) {
    return allFoodCountList.firstWhere(
          (foodCount) => foodCount.name == name,
    );
  }
}
