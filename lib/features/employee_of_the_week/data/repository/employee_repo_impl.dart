import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import 'package:my_office/features/employee_of_the_week/domain/repository/employee_repository.dart';

import '../model/employee_model.dart';

class EmployeeRepoImpl implements EmployeeRepository{
  final EmployeeFbDataSource _employeeFbDataSource;

  EmployeeRepoImpl(this._employeeFbDataSource);

  @override
  Future <List<EmployeeModel>> allStaffNames() async {
    return _employeeFbDataSource.allStaffNames();
  }

  @override
  Future<void> updatePrNameReason(context) async {
    return await _employeeFbDataSource.updatePrNameReason(context);
  }
}