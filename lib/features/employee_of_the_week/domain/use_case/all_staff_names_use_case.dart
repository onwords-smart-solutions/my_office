import '../../data/model/employee_model.dart';
import '../repository/employee_repository.dart';

class AllStaffNamesCase{
  final EmployeeRepository employeeRepository;

  AllStaffNamesCase({required this.employeeRepository});

  Future <List<EmployeeModel>>execute() async {
   return await employeeRepository.allStaffNames();
  }
}