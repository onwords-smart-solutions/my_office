import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';
import 'package:my_office/features/home/data/model/custom_punch_model.dart';

import '../model/staff_attendance_model.dart';

class AttendanceRepoImpl implements AttendanceRepository {
  final AttendanceFbDataSource _attendanceFbDataSource;

  AttendanceRepoImpl(this._attendanceFbDataSource);

  @override
  Future<CustomPunchModel?> checkTime(
    String staffId,
    String dep,
    String name,
  ) async {
    return await _attendanceFbDataSource.checkTime(staffId, dep, name);
  }

  @override
  Future<Either<ErrorResponse, bool>> getPunchingTime()async {
    return await _attendanceFbDataSource.getPunchingTime();
  }

  @override
  Future<Either<ErrorResponse, List<StaffAttendanceModel>>> getStaffDetails()async {
  return await _attendanceFbDataSource.getStaffDetails();
  }

  @override
  Future<void> printScreen() async{
    return await _attendanceFbDataSource.printScreen();
  }
}
