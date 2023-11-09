class ProxyAttendanceModel {
  final String uid;
  final String department;
  final String name;
  String? emailId;
  String? profileImage;

  ProxyAttendanceModel({
    required this.uid,
    required this.department,
    required this.name,
    this.emailId,
    this.profileImage,
  });
}