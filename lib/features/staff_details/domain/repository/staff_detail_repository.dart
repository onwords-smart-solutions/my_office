import 'package:either_dart/either.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';

import '../../../../core/utilities/response/error_response.dart';

abstract class StaffDetailRepository{
  Future<List<StaffDetailModel>> staffNames();

  Future<Either<ErrorResponse, bool>> removeStaffDetails(String uid);
}