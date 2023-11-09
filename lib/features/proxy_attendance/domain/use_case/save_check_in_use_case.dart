import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/proxy_attendance/domain/repository/proxy_attendance_repository.dart';

class SaveCheckInCase {
  final ProxyAttendanceRepository proxyAttendanceRepository;

  SaveCheckInCase({required this.proxyAttendanceRepository});

  Future<Either<ErrorResponse, bool>> execute(
    String userId,
    DateTime date,
    String reason,
    String proxyBy,
  ) async {
    return await proxyAttendanceRepository.saveCheckInProxy(
      userId,
      date,
      reason,
      proxyBy,
    );
  }
}
