import 'package:my_office/features/pr_bucket/data/data_source/pr_bucket_fb_data_source.dart';
import 'package:my_office/features/pr_bucket/domain/repository/pr_bucket_repository.dart';

class PrBucketRepoImpl extends PrBucketRepository{
 final PrBucketFbDataSource prBucketFbDataSource;

  PrBucketRepoImpl({required this.prBucketFbDataSource});

  @override
  Future<List<String>> getPrNames() async{
    return prBucketFbDataSource.getPrNames();
  }

  @override
  Future<Map<String, List<Map<String, String>>>> getCustomerState(String prName) {
   return prBucketFbDataSource.getCustomerState(prName);
  }
}