abstract class PrBucketRepository{
  Future<List<String>> getPrNames();
  Future<List<dynamic>> prBucketNames(String staffName);
  Future<List<dynamic>> bucketValues(String prName, String bucketName);
  Future<List<dynamic>> getCustomerData(mobile);
  Future<List<dynamic>> getCustomerState(String prName, String bucketName);

  }