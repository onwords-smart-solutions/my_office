import 'package:either_dart/either.dart';
import 'package:my_office/features/attendance/domain/repository/attendance_repository.dart';

import '../../../../core/utilities/response/error_response.dart';

class GetPunchTimeCase {
  final AttendanceRepository attendanceRepository;

  GetPunchTimeCase({required this.attendanceRepository});

  Future<Either<ErrorResponse, bool>> execute() async {
    return await attendanceRepository.getPunchingTime();
  }
}
