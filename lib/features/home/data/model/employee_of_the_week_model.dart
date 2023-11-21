import 'package:my_office/features/user/data/model/user_model.dart';

class EmployeeOfWeekData {
  final UserModel employee;
  final String reason;

  EmployeeOfWeekData({required this.employee, required this.reason});
}