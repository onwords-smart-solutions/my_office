
import 'package:my_office/features/attendance/presentation/view_model/staff_attendance_model.dart';

import '../repository/employee_repository.dart';

class AllStaffNamesCase{
  final EmployeeRepository employeeRepository;

  AllStaffNamesCase({required this.employeeRepository});

  Future <List<StaffAttendanceModel>>execute() async {
   return await employeeRepository.allStaffNames();
  }
}