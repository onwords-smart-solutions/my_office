import '../repository/pr_bucket_repository.dart';

class GetCustomerDataCase{
  final PrBucketRepository prBucketRepository;

  GetCustomerDataCase({required this.prBucketRepository});

  Future<List<dynamic>> execute(String prName, String bucketName) async{
    return prBucketRepository.getCustomerState(prName, bucketName);
  }
}