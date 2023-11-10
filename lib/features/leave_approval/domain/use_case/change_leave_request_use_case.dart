import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/leave_approval/domain/repository/leave_approval_repository.dart';

import '../../data/model/leave_approval_model.dart';

class ChangeLeaveRequestCase {
  final LeaveApprovalRepository leaveApprovalRepository;

  ChangeLeaveRequestCase({required this.leaveApprovalRepository});

  Future<Either<ErrorResponse, bool>> execute(
    StaffLeaveApprovalModel allData,
  ) async {
    return await leaveApprovalRepository.changeLeaveRequestStatus(
      allData,
    );
  }
}
