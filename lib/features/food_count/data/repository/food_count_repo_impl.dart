import 'package:intl/intl.dart';

import '../../domain/entity/food_count_entity.dart';
import '../../domain/repository/food_count_repository.dart';
import '../data_source/food_count_fb_data_source.dart';

class FoodCountRepoImpl implements FoodCountRepository {
  final FoodCountFbDataSource foodCountFbDataSource;

  FoodCountRepoImpl(this.foodCountFbDataSource);

  @override
  Future<List<FoodCountEntity>> getAllFoodCount(String month) async {
    // Use dataSource to interact with Firebase and convert the results to domain entities
    // ...
    List<FoodCountEntity> foodCounts = [];

    // Assume that month is passed in the format 'yyyy-MM' to match Firebase nodes
    final staffSnapshot = await foodCountFbDataSource.getStaff();
    final refreshmentsSnapshot = await foodCountFbDataSource.getRefreshments();

    if (staffSnapshot.exists) {
      for (var staff in staffSnapshot.children) {
        // Extract staff details
        final staffInfo = staff.value as Map<dynamic, dynamic>;
        final name = staffInfo['name']?.toString() ?? '';
        final dept = staffInfo['department']?.toString() ?? '';
        final email = staffInfo['email']?.toString() ?? '';
        final url = staffInfo['profileImage']?.toString() ?? '';

        // Extract food count details for the given month
        List<DateTime> foodDates = [];
        if (refreshmentsSnapshot.exists) {
          for (var detail in refreshmentsSnapshot.children) {
            final dateKey = detail.key ?? '';
            // Check if the key starts with the correct year and month
            if (dateKey.startsWith(month)) {
              final data = detail.value as Map<dynamic, dynamic>;
              final lunchData = data['Lunch'] as Map<dynamic, dynamic>?;
              final lunchList =
                  lunchData?['lunch_list'] as Map<dynamic, dynamic>?;
              if (lunchList != null && lunchList.containsKey(name)) {
                // Add the date to foodDates if the staff's name is in the lunch list
                DateTime date = DateFormat('yyyy-MM-dd').parse(dateKey);
                foodDates.add(date);
              }
            }
          }
        }

        // Add to the list of FoodCounts if there are any dates
        if (foodDates.isNotEmpty) {
          foodCounts.add(
            FoodCountEntity(
              name: name,
              department: dept,
              email: email,
              url: url,
              foodDates: foodDates,
            ),
          );
        }
      }
    }

    return foodCounts;
  }
}
