
abstract class PrDashRepository{
  Future<Map<String, dynamic>> fetchPrDashData();

  Future<void> updatePrDashData(String totalPrGetTarget, String totalPrTarget);
}