import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source.dart';
import 'package:my_office/features/hr_access/data/model/hr_access_staff_model.dart';
import 'package:my_office/features/hr_access/domain/repository/hr_access_repository.dart';

class HrAccessRepoImpl implements HrAccessRepository {
  final HrAccessFbDataSource hrAccessFbDataSource;

  HrAccessRepoImpl(this.hrAccessFbDataSource);

  @override
  Future<List<HrAccessModel>> getStaffDetails() async {
    return hrAccessFbDataSource.staffDetails();
  }

  @override
  Future<void> updateTimingForEmployees({
    required String uid,
    required String punchIn,
    required String punchOut,
  }) async {
    return await hrAccessFbDataSource.updateTimingForEmployees(
      uid: uid,
      punchIn: punchIn,
      punchOut: punchOut,
    );
  }

  @override
  Future<HrAccessModel?> createAccount({
    required String name,
    required String email,
    required String dep,
    required int phone,
    required DateTime dob,
  }) async {
    return await hrAccessFbDataSource.createAccount(
      name: name,
      email: email,
      dep: dep,
      phone: phone,
      dob: dob,
    );
  }
}
