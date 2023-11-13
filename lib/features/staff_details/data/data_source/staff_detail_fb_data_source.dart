import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';

abstract class StaffDetailFbDataSource{
  Future<List<StaffDetailModel>> staffNames();

  Future<Either<ErrorResponse, bool>> removeStaffDetails(String uid);
}