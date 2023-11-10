
import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/leave_approval/data/data_source/leave_approval_fb_data_source.dart';
import 'package:my_office/features/leave_approval/data/model/leave_approval_model.dart';
import 'package:my_office/features/leave_approval/domain/repository/leave_approval_repository.dart';

class LeaveApprovalRepoImpl implements LeaveApprovalRepository {
  final LeaveApprovalFbDataSource leaveApprovalFbDataSource;

  LeaveApprovalRepoImpl(this.leaveApprovalFbDataSource);

  @override
  Future<int> checkLeaveStatus(String date) async {
    return await leaveApprovalFbDataSource.checkLeaveStatus(date);
  }

  @override
  Future<Either<ErrorResponse, bool>> changeLeaveRequestStatus(
    StaffLeaveApprovalModel leaveData
  ) async {
    return await leaveApprovalFbDataSource.updateLeaveRequest(
     leaveData,
    );
  }
}
