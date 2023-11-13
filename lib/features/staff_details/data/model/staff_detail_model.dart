class StaffDetailModel {
  final String uid;
  final String department;
  final String name;
  String? emailId;
  String? profileImage;
  String? entryTime;

  StaffDetailModel({
    required this.uid,
    required this.department,
    required this.name,
    this.emailId,
    this.profileImage,
    this.entryTime,
  });
}