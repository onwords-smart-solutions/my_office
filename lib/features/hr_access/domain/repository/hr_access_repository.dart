import 'package:my_office/features/hr_access/data/model/hr_access_staff_model.dart';

abstract class HrAccessRepository {
  Future<List<HrAccessModel>> getStaffDetails();

  Future<void> updateTimingForEmployees({
    required String uid,
    required String punchIn,
    required String punchOut,
  });
}
