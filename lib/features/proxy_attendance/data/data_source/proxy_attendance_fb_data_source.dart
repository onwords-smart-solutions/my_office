import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';

import '../model/proxy_attendance_model.dart';

abstract class ProxyAttendanceFbDataSource {
  Future<Either<ErrorResponse, List<ProxyAttendanceModel>>> getStaffNames();

  Future<Either<ErrorResponse, bool>> checkInProxy({
    required String userId,
    required DateTime date,
    required DateTime initialTime,
    required String reason,
    required String proxyBy,
  });

  Future<Either<ErrorResponse, bool>> checkOutProxy({
   required String userId,
   required DateTime date,
   required DateTime initialTime,
   required String reason,
   required String proxyBy,
  });
}
