class LeaveModel{
  late String date;
  late String dep;
  late String uid;
  late String name;
  late String reason;
  late String status;
  late String type;
  late String updatedBy;
  late String isApproved;
  double? duration;
  late String? mode;

  LeaveModel({
    required this.date,
    required this.dep,
    required this.uid,
    required this.name,
    required this.reason,
    required this.status,
    required this.type,
    required this.updatedBy,
    required this.isApproved,
    required this.duration,
    required this.mode,
});
}