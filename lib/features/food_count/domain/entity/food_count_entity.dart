
class FoodCountEntity {
  final String name;
  final String department;
  final String email;
  final String url;
  final List<DateTime> foodDates;

  FoodCountEntity({
    required this.name,
    required this.department,
    required this.email,
    required this.url,
    required this.foodDates,
  });
}
