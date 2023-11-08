import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';

class PrintScreenCase{
  final AttendanceRepository attendanceRepository;

  PrintScreenCase({required this.attendanceRepository});

  Future<void> execute() async => await attendanceRepository.printScreen();
}