class StaffAttendanceModel {
  final String uid;
  final String department;
  final String name;
  String? entryTime;

  StaffAttendanceModel({
    required this.uid,
    required this.department,
    required this.name,
    this.entryTime,
  });
}
