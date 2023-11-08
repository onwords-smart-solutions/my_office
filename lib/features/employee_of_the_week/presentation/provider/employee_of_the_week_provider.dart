import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/attendance/presentation/view_model/staff_attendance_model.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/all_staff_names_use_case.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/update_pr_name_reason_use_case.dart';


class EmployeeProvider extends ChangeNotifier {
  final AllStaffNamesCase _allStaffNamesCase;
  final UpdatePrNameReasonCase _updatePrNameReasonCase;

  EmployeeProvider(
      this._allStaffNamesCase,
      this._updatePrNameReasonCase,
      );

  List<StaffAttendanceModel> _staff = [];
  List<StaffAttendanceModel> get staff => _staff;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<List<StaffAttendanceModel>> fetchAllStaff() async {
    _isLoading = true;
    _staff = await _allStaffNamesCase.execute();
    _isLoading = false;
    return _staff;
  }



  Future <void> updatePrNameReason(context) async {
    _updatePrNameReasonCase.execute(context);
    notifyListeners();
  }
}
