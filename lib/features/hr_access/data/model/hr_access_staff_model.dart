class HrAccessModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  String? profilePic;
  final DateTime dob;
  final int mobile;
  String punchIn;
  String punchOut;

  HrAccessModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.department,
    this.profilePic,
    required this.dob,
    required this.mobile,
    required this.punchIn,
    required this.punchOut,
  });
}
