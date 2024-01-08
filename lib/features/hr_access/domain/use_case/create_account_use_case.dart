import 'package:my_office/features/hr_access/domain/repository/hr_access_repository.dart';

import '../../data/model/hr_access_staff_model.dart';

class CreateAccountCase {
  final HrAccessRepository hrAccessRepository;

  CreateAccountCase({required this.hrAccessRepository});

  Future<HrAccessModel?> execute({
    required String name,
    required String email,
    required String dep,
    required int phone,
    required DateTime dob,
  }) async {
    return hrAccessRepository.createAccount(
      name: name,
      email: email,
      dep: dep,
      phone: phone,
      dob: dob,
    );
  }
}
