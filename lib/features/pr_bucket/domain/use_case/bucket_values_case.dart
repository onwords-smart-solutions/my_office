import '../repository/pr_bucket_repository.dart';

class BucketValuesCase{
  final PrBucketRepository prBucketRepository;

  BucketValuesCase({required this.prBucketRepository});

  Future<List<dynamic>> execute(String prName, String bucketName){
    return prBucketRepository.bucketValues(prName, bucketName);
  }
}