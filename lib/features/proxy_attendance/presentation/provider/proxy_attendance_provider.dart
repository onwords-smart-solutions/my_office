import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/proxy_attendance/data/model/proxy_attendance_model.dart';
import 'package:my_office/features/proxy_attendance/domain/use_case/proxy_staff_names_use_case.dart';
import 'package:my_office/features/proxy_attendance/domain/use_case/save_check_in_use_case.dart';
import 'package:my_office/features/proxy_attendance/domain/use_case/save_check_out_use_case.dart';

import '../../../../core/utilities/response/error_response.dart';

class ProxyAttendanceProvider extends ChangeNotifier {
  final ProxyStaffNamesCase _proxyStaffNamesCase;
  final SaveCheckInCase _saveCheckInCase;
  final SaveCheckOutCase _saveCheckOutCase;

  List<ProxyAttendanceModel> allStaffs = [];
  bool isLoading = false;

  ProxyAttendanceProvider(
    this._proxyStaffNamesCase,
    this._saveCheckInCase,
    this._saveCheckOutCase,
  );

  //Getting all staff names
  Future<List<ProxyAttendanceModel>> fetchAllStaffNames() async {
    isLoading = true;
    Either<ErrorResponse, List<ProxyAttendanceModel>> allStaffNames =
        await _proxyStaffNamesCase.execute();
    if (allStaffNames.isRight) {
      isLoading = false;
    }
    return allStaffs = allStaffNames.right;
  }

  //Saving check in proxy
  Future<Either<ErrorResponse, bool>> updateCheckInProxy(String userId, DateTime date, String reason, String proxyBy ) async {
    return await _saveCheckInCase.execute(userId, date, reason, proxyBy);
  }

  //Saving check out proxy
  Future<Either<ErrorResponse, bool>> updateCheckOutProxy(String userId, DateTime date, String reason, String proxyBy) async {
   return await _saveCheckOutCase.execute(userId, date, reason, proxyBy);
  }
}
