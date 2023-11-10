class StaffLeaveApprovalModel {
  final String uid;
  final String name;
  final String date;
  final String year;
  final String month;
  final String reason;
  final String status;
  final String type;
  final String department;

  StaffLeaveApprovalModel({
    required this.name,
    required this.uid,
    required this.date,
    required this.status,
    required this.month,
    required this.year,
    required this.reason,
    required this.type,
    required this.department,
  });
}
