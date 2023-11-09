import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';

import '../model/proxy_attendance_model.dart';

abstract class ProxyAttendanceFbDataSource {
  Future<Either<ErrorResponse, List<ProxyAttendanceModel>>> getStaffNames();

  Future<Either<ErrorResponse, bool>> checkInProxy(
    String userId,
    DateTime date,
    String reason,
    String proxyBy,
  );

  Future<Either<ErrorResponse, bool>> checkOutProxy(
    String userId,
    DateTime date,
    String reason,
    String proxyBy,
  );
}
