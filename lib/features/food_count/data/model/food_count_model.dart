class FoodCountModel {
  final String name;
  final String department;
  final String email;
  final String url;
  final List<dynamic> foodDates;

  FoodCountModel({
    required this.name,
    required this.url,
    required this.email,
    required this.department,
    required this.foodDates,
  });
}
