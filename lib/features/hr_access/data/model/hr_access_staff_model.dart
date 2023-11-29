class HrAccessModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  String? profilePic;
  int? dob;
  int? mobile;
  String punchIn;
  String punchOut;

  HrAccessModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    this.profilePic,
    this.dob,
    this.mobile,
    required this.punchIn,
    required this.punchOut,
  });
}
