import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/attendance/data/data_source/attendance_fb_data_source.dart';
import 'package:my_office/features/attendance/data/model/punch_model.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';

import '../model/staff_attendance_model.dart';

class AttendanceRepoImpl implements AttendanceRepository {
  final AttendanceFbDataSource _attendanceFbDataSource;

  AttendanceRepoImpl(this._attendanceFbDataSource);

  @override
  Future<AttendancePunchModel?> checkTime(
    String staffId,
    String department,
    String name,
    DateTime date,
      String punchIn,
      String punchOut,
  ) async {
    DatabaseEvent event = await _attendanceFbDataSource.getAttendanceData(staffId, date);

    if (!event.snapshot.exists) {
      return null;
    }

    var attendanceData = event.snapshot.value as Map<dynamic, dynamic>;
    DateTime? checkInTime;
    DateTime? checkOutTime;
    bool isProxy = false;
    String proxyInBy = '';
    String proxyOutBy = '';
    String proxyInReason = '';
    String proxyOutReason = '';

    if (attendanceData.containsKey('check_in')) {
      checkInTime = _parseTime(attendanceData['check_in'], date);
      if (attendanceData.containsKey('proxy_in')) {
        var proxyData = attendanceData['proxy_in'] as Map<dynamic, dynamic>;
        proxyInBy = proxyData['proxy_by'];
        proxyInReason = proxyData['reason'];
        isProxy = true;
      }
    }

    if (attendanceData.containsKey('check_out')) {
      checkOutTime = _parseTime(attendanceData['check_out'], date);
      if (attendanceData.containsKey('proxy_out')) {
        var proxyData = attendanceData['proxy_out'] as Map<dynamic, dynamic>;
        proxyOutBy = proxyData['proxy_by'];
        proxyOutReason = proxyData['reason'];
        isProxy = true;
      }
    }

    return AttendancePunchModel(
      name: name,
      staffId: staffId,
      department: department,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      isProxy: isProxy,
      checkInProxyBy: proxyInBy,
      checkInReason: proxyInReason,
      checkOutProxyBy: proxyOutBy,
      checkOutReason: proxyOutReason,
      punchIn: punchIn,
      punchOut: punchOut,
    );
  }

  DateTime? _parseTime(String time, DateTime date) {
    try {
      List<String> parts = time.split(':');
      return DateTime(date.year, date.month, date.day, int.parse(parts[0]), int.parse(parts[1]));
    } catch (e) {
      // Handle exception or log error
      return null;
    }
  }

  @override
  Future<List<StaffAttendanceModel>> getStaffDetails() async {
    List<StaffAttendanceModel> staffList = [];
    DatabaseEvent event = await _attendanceFbDataSource.getStaffData();

    for (var staff in event.snapshot.children) {
      var data = staff.value as Map<Object?, Object?>;
      StaffAttendanceModel staffMember = StaffAttendanceModel(
        uid: staff.key.toString(),
        department: data['department'].toString(),
        name: data['name'].toString(),
        punchIn: data['punch_in'].toString(),
        punchOut: data['punch_out'].toString(),
      );
      staffList.add(staffMember);
    }

    return staffList;
  }
}
