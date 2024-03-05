abstract class PrBucketFbDataSource{
  Future<List<String>> getPrNames();
  Future <Map<String, List<Map<String, String>>>> getCustomerState(String prName);
}