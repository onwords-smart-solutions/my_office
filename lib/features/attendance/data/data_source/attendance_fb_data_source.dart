import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';

import '../../../home/data/model/custom_punch_model.dart';
import '../model/staff_attendance_model.dart';

abstract class AttendanceFbDataSource {
  Future<Either<ErrorResponse,bool>> getPunchingTime();

  Future<Either<ErrorResponse, List<StaffAttendanceModel>>> getStaffDetails();

  Future<CustomPunchModel?> checkTime(String staffId,
      String dep,
      String name,);

  Future<void> printScreen();
}