import 'package:my_office/features/leave_approval/domain/repository/leave_approval_repository.dart';

class CheckLeaveStatusCase{
  final LeaveApprovalRepository leaveApprovalRepository;

  CheckLeaveStatusCase({required this.leaveApprovalRepository});

  Future<int> execute(String date) {
    return leaveApprovalRepository.checkLeaveStatus(date);
  }
}