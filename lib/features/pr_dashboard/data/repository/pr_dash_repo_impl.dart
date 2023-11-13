import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';
import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';

class PrDashRepoImpl implements PrDashRepository{
  final PrDashFbDataSource prDashFbDataSource;

  PrDashRepoImpl(this.prDashFbDataSource);


  @override
  Future<Map<String, dynamic>> fetchPrDashData()async {
    return await prDashFbDataSource.getPrDashboardData();
  }

  @override
  Future<void> updatePrDashData(String totalPrGetTarget, String totalPrTarget) {
    return prDashFbDataSource.updatePrDashboardData(totalPrGetTarget, totalPrTarget);
  }

}