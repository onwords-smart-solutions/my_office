import '../repository/hr_access_repository.dart';

class UpdateTimingForEmployeesCase {
  final HrAccessRepository hrAccessRepository;

  UpdateTimingForEmployeesCase({required this.hrAccessRepository});

  Future<void> execute({
    required String uid,
    required String punchIn,
    required String punchOut,
  }) async {
    return await hrAccessRepository.updateTimingForEmployees(
      uid: uid,
      punchIn: punchIn,
      punchOut: punchOut,
    );
  }
}
