import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/attendance/domain/use_case/check_time_use_case.dart';
import 'package:my_office/features/attendance/domain/use_case/get_punching_time_use_case.dart';
import 'package:my_office/features/attendance/domain/use_case/get_staff_details_use_case.dart';
import 'package:my_office/features/attendance/domain/use_case/print_screen_use_case.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../home/data/model/custom_punch_model.dart';
import '../../data/model/staff_attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final CheckTimeCase _checkTimeCase;
  final GetPunchTimeCase _getPunchTimeCase;
  final GetAllStaffDetailsCase _getAllStaffDetailsCase;
  final PrintScreenCase _printScreenCase;

  AttendanceProvider(
    this._printScreenCase,
    this._getAllStaffDetailsCase,
    this._getPunchTimeCase,
    this._checkTimeCase,
  );

  Future<CustomPunchModel?> checkTime(
      String staffId,
      String dep,
      String name,
      ) async => await _checkTimeCase.execute(staffId, dep, name);

  Future<Either<ErrorResponse,bool>> getPunchingTime() async {
    try{
      return await _getPunchTimeCase.execute();
    }catch(e){
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered while fetching punching time',
          error: 'Error caught while getting punching details $e',
        ),
      );
    }
  }


  Future<Either<ErrorResponse, List<StaffAttendanceModel>>> getStaffDetails() async =>
      await _getAllStaffDetailsCase.execute();

  Future<void> printScreen() async =>
      await _printScreenCase.execute();
}
