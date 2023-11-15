import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../model/custom_punch_model.dart';
import '../model/staff_access_model.dart';

abstract class HomeFbDataSource {
  Future<Either<ErrorResponse,List<String>>> getManagementList();

  Future<Either<ErrorResponse ,List<String>>> getTLList();

  Future<Either<ErrorResponse, List<String>>>getRNDTLList();

  Future<Either<ErrorResponse, List<String>>> getInstallationMemberList();

  Future<Either<ErrorResponse, List<StaffAccessModel>>> getStaffAccess({
    required UserEntity staff,
  });

  Future<Either<ErrorResponse, CustomPunchModel?>> getPunchingTime(
    String staffId,
    String name,
    String department,
  );

  Future<Either<ErrorResponse, List<UserEntity>>> getAllBirthday();

  Future<Either<ErrorResponse, List<UserEntity>>> getStaffDetails();

  int getRandomNumber();

  Future<Either<ErrorResponse, bool>> birthdaySubmitForm(context);

  Future<Either<ErrorResponse, bool>> phoneNumberSubmitForm(context);

  // Future<CustomPunchModel> getPunchingTime();
}
