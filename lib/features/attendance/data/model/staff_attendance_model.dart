class StaffAttendanceModel {
  final String uid;
  final String department;
  final String name;
  final String punchIn;
  final String punchOut;
  String? emailId;
  String? profileImage;
  String? entryTime;

  StaffAttendanceModel({
    required this.uid,
    required this.department,
    required this.name,
    required this.punchIn,
    required this.punchOut,
    this.emailId,
    this.profileImage,
    this.entryTime,
  });
}