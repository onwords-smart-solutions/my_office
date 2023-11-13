import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';


class PrDashboardCase {
  final PrDashRepository prDashRepository;

  PrDashboardCase({required this.prDashRepository});

  Future<Map<String, dynamic>> execute()async {
    return await prDashRepository.fetchPrDashData();
  }
}
