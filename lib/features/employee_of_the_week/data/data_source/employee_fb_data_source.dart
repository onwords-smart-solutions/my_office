
import '../model/employee_model.dart';

abstract class EmployeeFbDataSource{
  Future <List<EmployeeModel>> allStaffNames();

  Future <void> updatePrNameReason(context);
}