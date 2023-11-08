import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';
import '../../../home/presentation/view_model/custom_punch_model.dart';

class CheckTimeCase{
  final AttendanceRepository attendanceRepository;

  CheckTimeCase({required this.attendanceRepository});

  Future<CustomPunchModel?> execute(
      String staffId,
      String dep,
      String name,
      ) async =>
    await attendanceRepository.checkTime(staffId, dep, name);

}