import 'package:either_dart/src/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/staff_details/data/data_source/staff_detail_fb_data_source.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';
import 'package:my_office/features/staff_details/domain/repository/staff_detail_repository.dart';

class StaffDetailRepoImpl implements StaffDetailRepository {
  final StaffDetailFbDataSource staffDetailFbDataSource;

  StaffDetailRepoImpl({required this.staffDetailFbDataSource});

  @override
  Future<Either<ErrorResponse, bool>> removeStaffDetails(String uid) async {
    return await staffDetailFbDataSource.removeStaffDetails(uid);
  }

  @override
  Future<List<StaffDetailModel>> staffNames() async {
    return await staffDetailFbDataSource.staffNames();
  }
}
