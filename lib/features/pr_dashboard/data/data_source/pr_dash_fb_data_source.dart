import '../../domain/entity/pr_dash_entity.dart';

abstract class PrDashFbDataSource{
  Future<PrDashboardData> fetchPrDashboardData();

  Future<void> updatePrDashboard(context);
}