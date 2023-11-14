import 'package:flutter/cupertino.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/all_staff_names_use_case.dart';

import '../../data/model/employee_model.dart';


class EmployeeProvider extends ChangeNotifier {
  final AllStaffNamesCase _allStaffNamesCase;

  EmployeeProvider(
      this._allStaffNamesCase,
      );

  List<EmployeeModel> staff = [];
  List<EmployeeModel> get allStaff => staff;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<List<EmployeeModel>> fetchAllStaff() async {
    _isLoading = true;
    staff = await _allStaffNamesCase.execute();
    _isLoading = false;
    return staff;
  }
}
