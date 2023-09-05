
class CustomPunchModel {
  final String name;
  final String staffId;
  final String department;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool isProxy;
  final String checkInProxyBy;
  final String checkOutProxyBy;
  final String checkInReason;
  final String checkOutReason;

  CustomPunchModel({
    required this.name,
    required this.staffId,
    required this.department,
    this.checkInTime,
    this.checkOutTime,
    this.isProxy = false,
    this.checkInProxyBy = '',
    this.checkOutProxyBy = '',
    this.checkInReason = '',
    this.checkOutReason = '',
  });

  @override
  String toString() {
    return 'CHECK IN $checkInTime CHECKOUT $checkOutTime';
  }
}