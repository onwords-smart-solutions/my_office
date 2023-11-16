import '../../data/model/punch_model.dart';
import '../../data/model/staff_attendance_model.dart';

abstract class AttendanceRepository {
  Future<List<StaffAttendanceModel>> getStaffDetails();

  Future<AttendancePunchModel?> checkTime(
      String staffId, String department, String name, DateTime date);
}
