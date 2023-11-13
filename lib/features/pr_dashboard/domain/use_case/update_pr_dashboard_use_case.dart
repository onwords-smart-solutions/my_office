import '../repository/pr_dash_repository.dart';

class UpdatePrDashboardCase{
  final PrDashRepository prDashRepository;

  UpdatePrDashboardCase({required this.prDashRepository});

  Future<void> execute(String totalPrGetTarget, String totalPrTarget) async {
    if (totalPrGetTarget.isEmpty || totalPrTarget.isEmpty) {
      throw Exception('Enter all PR data');
    }
    return await prDashRepository.updatePrDashData(totalPrGetTarget, totalPrTarget);
  }

}