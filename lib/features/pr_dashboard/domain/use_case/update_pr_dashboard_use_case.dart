import '../repository/pr_dash_repository.dart';

class UpdatePrDashboardCase{
  final PrDashRepository prDashRepository;

  UpdatePrDashboardCase({required this.prDashRepository});

  Future<void> execute(context) async {
    return prDashRepository.updatePrDashboard(context);
  }

}