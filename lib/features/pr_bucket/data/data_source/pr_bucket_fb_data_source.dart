abstract class PrBucketFbDataSource{
  Future<List<String>> getPrNames();
  Future<List<dynamic>>  prBucketNames(String staff);
  Future<List<dynamic>> bucketValues(String prName, String bucketName);
  Future<List<dynamic>> getCustomerData(dynamic mobile);
}