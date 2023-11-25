import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source.dart';
import 'package:my_office/features/hr_access/data/model/hr_access_staff_model.dart';
import 'package:my_office/features/hr_access/domain/repository/hr_access_repository.dart';

class HrAccessRepoImpl implements HrAccessRepository{
  final HrAccessFbDataSource hrAccessFbDataSource;

  HrAccessRepoImpl(this.hrAccessFbDataSource);

  @override
  Future<List<HrAccessModel>> getStaffDetails() async{
    return await hrAccessFbDataSource.staffDetails();
  }
}