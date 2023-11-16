import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'attendance_fb_data_source.dart';


class AttendanceFbDataSourceImpl implements AttendanceFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<DatabaseEvent> getAttendanceData(String staffId, DateTime date) async {
    String yearFormat = DateFormat('yyyy').format(date);
    String monthFormat = DateFormat('MM').format(date);
    String dateFormat = DateFormat('dd').format(date);

    return await ref.child('attendance/$yearFormat/$monthFormat/$dateFormat/$staffId').once();
  }

  @override
  Future<DatabaseEvent> getStaffData() async {
    return await ref.child('staff').once();
  }

}
