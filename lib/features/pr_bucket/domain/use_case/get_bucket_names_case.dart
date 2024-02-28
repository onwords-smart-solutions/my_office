import 'package:my_office/features/pr_bucket/domain/repository/pr_bucket_repository.dart';

class GetBucketNamesCase{
  final PrBucketRepository prBucketRepository;

  GetBucketNamesCase({required this.prBucketRepository});

  Future<List<dynamic>> execute(String staffName){
    return prBucketRepository.prBucketNames(staffName);
  }
}