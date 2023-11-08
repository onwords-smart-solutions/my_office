import 'package:my_office/features/pr_dashboard/data/repository/pr_dash_repo_impl.dart';
import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';

import '../entity/pr_dash_entity.dart';

class PrDashboardUseCase {
  final PrDashRepository prDashRepository;

  PrDashboardUseCase({required this.prDashRepository});

  Future<PrDashboardData> fetchPrDashboardData() {
    return prDashRepository.prDashboardDetails();
  }
}
