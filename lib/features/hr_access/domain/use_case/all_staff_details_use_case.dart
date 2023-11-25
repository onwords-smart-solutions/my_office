import 'package:my_office/features/hr_access/data/model/hr_access_staff_model.dart';
import 'package:my_office/features/hr_access/domain/repository/hr_access_repository.dart';

class AllStaffDetailsCase{
  final HrAccessRepository hrAccessRepository;

  AllStaffDetailsCase({required this.hrAccessRepository});

  Future<List<HrAccessModel>> getStaffDetails() async {
    return  hrAccessRepository.getStaffDetails();
  }
}