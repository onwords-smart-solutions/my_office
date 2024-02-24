class UserEntity {
  final String uid;
  final String dep;
  final String email;
  final String name;
  int dob;
  int mobile;
  String url;
  String uniqueId;
  String? saleAchieved;
  String? saleTarget;

  UserEntity({
    required this.uid,
    required this.dep,
    required this.email,
    required this.name,
    required this.dob,
    required this.mobile,
    required this.url,
    required this.uniqueId,
    this.saleAchieved,
    this.saleTarget,
  });

  @override
  String toString() {
    return "Name : $name mobile $mobile";
  }
}
