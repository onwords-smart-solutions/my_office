import 'package:either_dart/either.dart';
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
  Future<Either<ErrorResponse, bool>> saveCheckInProxy({
   required String userId,
   required DateTime date,
   required DateTime initialTime,
   required String reason,
   required String proxyBy,
  }) async {
    return await proxyAttendanceFbDataSource.checkInProxy(
     userId: userId,
      date: date,
      initialTime: initialTime,
      reason: reason,
     proxyBy:  proxyBy,
    );
  }

  @override
  Future<Either<ErrorResponse, bool>> saveCheckOutProxy({
    required String userId,
    required DateTime date,
    required DateTime initialTime,
    required String reason,
    required String proxyBy,
  }) async {
    return await proxyAttendanceFbDataSource.checkOutProxy(
      userId: userId,
      date: date,
      initialTime: initialTime,
      reason: reason,
      proxyBy: proxyBy,
    );
  }
}
