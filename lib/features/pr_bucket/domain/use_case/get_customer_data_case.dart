import '../repository/pr_bucket_repository.dart';

class GetCustomerDataCase{
  final PrBucketRepository prBucketRepository;

  GetCustomerDataCase({required this.prBucketRepository});

  Future<Map<String, List<Map<String, String>>>> execute(String prName) async{
    return prBucketRepository.getCustomerState(prName);
  }
}