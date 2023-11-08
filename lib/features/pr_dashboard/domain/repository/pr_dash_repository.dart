import '../entity/pr_dash_entity.dart';

abstract class PrDashRepository{
  Future<PrDashboardData> prDashboardDetails();

  Future<void> updatePrDashboard(context);
}