import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/leave_approval/data/model/leave_approval_model.dart';

abstract class LeaveApprovalFbDataSource {
  Future<int> checkLeaveStatus(String date);

  Future<Either<ErrorResponse, bool>> updateLeaveRequest(
    StaffLeaveApprovalModel data,
  );
}
