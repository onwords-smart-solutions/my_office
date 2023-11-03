import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';

import '../../../../models/custom_punching_model.dart';
import '../../../../models/staff_access_model.dart';
import '../../../../models/staff_model.dart';

abstract class HomeFbDataSource {
  Future<Either<ErrorResponse,List<String>>> getManagementList();

  Future<Either<ErrorResponse ,List<String>>> getTLList();

  Future<Either<ErrorResponse, List<String>>>getRNDTLList();

  Future<Either<ErrorResponse, List<String>>> getInstallationMemberList();

  Future<Either<ErrorResponse, List<StaffAccessModel>>> getStaffAccess({
    required StaffModel staff,
  });

  Future<Either<ErrorResponse, CustomPunchModel?>> getPunchingTime(
    String staffId,
    String name,
    String department,
  );

  Future<Either<ErrorResponse, List<StaffModel>>> getAllBirthday();

  Future<Either<ErrorResponse, List<StaffModel>>> getStaffDetails();

  int getRandomNumber();
}
