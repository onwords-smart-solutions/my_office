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
  Future<List> prBucketNames(String staffName) async{
    return prBucketFbDataSource.prBucketNames(staffName);
  }

  @override
  Future<List<dynamic>> bucketValues(String prName, String bucketName) async{
    return prBucketFbDataSource.bucketValues(prName, bucketName);
  }

  @override
  Future<List<dynamic>> getCustomerData(mobile) async{
    return prBucketFbDataSource.getCustomerData(mobile);
  }

  @override
  Future<List> getCustomerState(String prName, String bucketName) {
   return prBucketFbDataSource.getCustomerState(prName, bucketName);
  }
}