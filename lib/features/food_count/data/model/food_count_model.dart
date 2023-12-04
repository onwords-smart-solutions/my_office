class FoodCountModel {
  final String name;
  final String department;
  final String email;
  final String url;
  final List<dynamic> foodDates;
  final String month;

  FoodCountModel({
    required this.name,
    required this.url,
    required this.email,
    required this.department,
    required this.foodDates,
    required this.month,
  });
}
