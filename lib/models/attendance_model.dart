
class AttendanceModel{
  final String checkInTime;
  final String checkOutTime;
  final String uid;
  final String? proxyBy;
  final String? reason;

  AttendanceModel({
    required this.checkInTime,
    required this.checkOutTime,
    required this.uid,
    this.proxyBy,
    this.reason,
});
}