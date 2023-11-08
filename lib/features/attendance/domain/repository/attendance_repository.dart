import 'package:either_dart/either.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../home/presentation/view_model/custom_punch_model.dart';
import '../../presentation/view_model/staff_attendance_model.dart';

abstract class AttendanceRepository{
  Future<void> getPunchingTime();

  Future<Either<ErrorResponse, List<StaffAttendanceModel>>> getStaffDetails();

  Future<CustomPunchModel?> checkTime(String staffId,
      String dep,
      String name,);

  Future<void> printScreen();
}