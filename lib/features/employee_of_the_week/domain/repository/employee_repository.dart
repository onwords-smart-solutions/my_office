
import 'package:my_office/features/attendance/presentation/view_model/staff_attendance_model.dart';

abstract class EmployeeRepository{
  Future<List<StaffAttendanceModel>> allStaffNames();

  Future <void> updatePrNameReason(context);

}