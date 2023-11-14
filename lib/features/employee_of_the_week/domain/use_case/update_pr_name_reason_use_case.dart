import 'package:my_office/features/employee_of_the_week/domain/repository/employee_repository.dart';

class UpdatePrNameReasonCase{
  final EmployeeRepository employeeRepository;

  UpdatePrNameReasonCase({required this.employeeRepository});

  Future<void> execute(String employeeUid, String reason) async {
    return await employeeRepository.updateEmployeeOfWeek(employeeUid, reason);
  }
}