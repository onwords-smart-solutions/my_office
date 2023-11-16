import 'package:firebase_database/firebase_database.dart';

abstract class AttendanceFbDataSource {
  Future<DatabaseEvent> getStaffData();
  Future<DatabaseEvent> getAttendanceData(String staffId, DateTime date);
}