import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/proxy_attendance/data/model/proxy_attendance_model.dart';
import 'package:my_office/features/proxy_attendance/domain/repository/proxy_attendance_repository.dart';

class ProxyStaffNamesCase{
  final ProxyAttendanceRepository proxyAttendanceRepository;

  ProxyStaffNamesCase({required this.proxyAttendanceRepository});

  Future<Either<ErrorResponse, List<ProxyAttendanceModel>>> execute()async{
    return await proxyAttendanceRepository.getStaffNames();
  }
}