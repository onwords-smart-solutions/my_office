import 'package:my_office/features/attendance/presentation/view_model/staff_attendance_model.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import 'package:my_office/features/employee_of_the_week/domain/repository/employee_repository.dart';

class EmployeeRepoImpl implements EmployeeRepository{
  final EmployeeFbDataSource _employeeFbDataSource;

  EmployeeRepoImpl(this._employeeFbDataSource);

  @override
  Future <List<StaffAttendanceModel>> allStaffNames() async {
    return _employeeFbDataSource.allStaffNames();
  }

  @override
  Future<void> updatePrNameReason(context) async {
    return await _employeeFbDataSource.updatePrNameReason(context);
  }
}