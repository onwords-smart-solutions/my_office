import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../model/staff_access_model.dart';

abstract class HomeFbDataSource {
  Future<Either<ErrorResponse, List<String>>> getManagementList();

  Future<Either<ErrorResponse, List<String>>> getTLList();

  Future<Either<ErrorResponse, List<String>>> getInstallationMemberList();

  Future<Either<ErrorResponse, List<StaffAccessModel>>> getStaffAccess({
    required UserEntity staff,
  });

  Future<Map<Object?, Object?>?> fetchAttendanceData(
      String staffId, DateTime date);

  Future<Either<ErrorResponse, List<UserEntity>>> getAllBirthday();

  Future<Either<ErrorResponse, List<UserEntity>>> getStaffDetails();

  int getRandomNumber();

  Future<Map<Object?, Object?>> getAppVersionInfo();

  Future<Map<Object?, Object?>> getEmployeeOfWeek();

  Future<Map<Object?, Object?>> getAllStaffDetails(String uid);

  Future<UserEntity?> salesData(String userId);
}
