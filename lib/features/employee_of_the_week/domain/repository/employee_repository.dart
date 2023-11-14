import '../../data/model/employee_model.dart';

abstract class EmployeeRepository{
  Future<List<EmployeeModel>> allStaffNames();

  Future<void> updateEmployeeOfWeek(String employeeUid, String reason);

}