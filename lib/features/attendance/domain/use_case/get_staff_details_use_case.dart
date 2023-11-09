import 'package:either_dart/either.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../data/model/staff_attendance_model.dart';

class GetAllStaffDetailsCase{
  final AttendanceRepository attendanceRepository;

  GetAllStaffDetailsCase({required this.attendanceRepository});

  Future<Either<ErrorResponse, List<StaffAttendanceModel>>> execute() async =>
      await attendanceRepository.getStaffDetails();
}