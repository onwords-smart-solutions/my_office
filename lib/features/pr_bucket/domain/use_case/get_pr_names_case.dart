import 'package:my_office/features/pr_bucket/domain/repository/pr_bucket_repository.dart';

class GetPrNamesCase {
  final PrBucketRepository prBucketRepository;

  GetPrNamesCase({required this.prBucketRepository});

  Future<List<String>> execute () async{
    return prBucketRepository.getPrNames();
  }
}