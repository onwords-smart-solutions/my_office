
abstract class PrDashFbDataSource{
  Future<Map<String, dynamic>> getPrDashboardData();

  Future<void> updatePrDashboardData(String totalPrGetTarget, String totalPrTarget);
}