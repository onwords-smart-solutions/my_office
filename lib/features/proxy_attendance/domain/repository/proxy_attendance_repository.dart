import 'package:either_dart/either.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../data/model/proxy_attendance_model.dart';

abstract class ProxyAttendanceRepository{
  Future <Either<ErrorResponse, List<ProxyAttendanceModel>>> getStaffNames();

  Future<Either<ErrorResponse, bool>> saveCheckInProxy(
      String userId,
      DateTime date,
      String reason,
      String proxyBy,
      );

  Future<Either<ErrorResponse, bool>> saveCheckOutProxy(
      String userId,
      DateTime date,
      String reason,
      String proxyBy,
      );

}