import 'package:either_dart/src/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/proxy_attendance/data/data_source/proxy_attendance_fb_data_source.dart';
import 'package:my_office/features/proxy_attendance/data/model/proxy_attendance_model.dart';
import 'package:my_office/features/proxy_attendance/domain/repository/proxy_attendance_repository.dart';

class ProxyAttendanceRepoImpl implements ProxyAttendanceRepository {
  final ProxyAttendanceFbDataSource proxyAttendanceFbDataSource;

  ProxyAttendanceRepoImpl(this.proxyAttendanceFbDataSource);

  @override
  Future<Either<ErrorResponse, List<ProxyAttendanceModel>>>
      getStaffNames() async {
    return await proxyAttendanceFbDataSource.getStaffNames();
  }

  @override
  Future<Either<ErrorResponse, bool>> saveCheckInProxy(
    String userId,
    DateTime date,
    String reason,
    String proxyBy,
  ) async {
    return await proxyAttendanceFbDataSource.checkInProxy(
      userId,
      date,
      reason,
      proxyBy,
    );
  }

  @override
  Future<Either<ErrorResponse, bool>> saveCheckOutProxy(
    String userId,
    DateTime date,
    String reason,
    String proxyBy,
  ) async {
    return await proxyAttendanceFbDataSource.checkOutProxy(
      userId,
      date,
      reason,
      proxyBy,
    );
  }
}
