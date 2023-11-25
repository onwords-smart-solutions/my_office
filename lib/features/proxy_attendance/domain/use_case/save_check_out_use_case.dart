import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/proxy_attendance/domain/repository/proxy_attendance_repository.dart';

class SaveCheckOutCase {
  final ProxyAttendanceRepository proxyAttendanceRepository;

  SaveCheckOutCase({required this.proxyAttendanceRepository});

  Future<Either<ErrorResponse, bool>> execute(
    String userId,
    DateTime date,
      DateTime initialTime,
    String reason,
    String proxyBy,
  ) async {
    return await proxyAttendanceRepository.saveCheckOutProxy(
      userId:userId,
      date:date,
      initialTime: initialTime,
      reason: reason,
      proxyBy: proxyBy,
    );
  }
}
