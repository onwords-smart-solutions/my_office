class LeaveHistoryModel {
  final DateTime date;
  final String reason;
  final String status;
  final String updatedBy;

  LeaveHistoryModel({
    required this.date,
    required this.reason,
    required this.status,
    required this.updatedBy,
  });
}
