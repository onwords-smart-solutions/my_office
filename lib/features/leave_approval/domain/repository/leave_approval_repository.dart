import 'package:either_dart/either.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../data/model/leave_approval_model.dart';

abstract class LeaveApprovalRepository {
  Future<int> checkLeaveStatus(String date);

  Future<Either<ErrorResponse, bool>> changeLeaveRequestStatus(
    StaffLeaveApprovalModel leaveData,
  );
}
