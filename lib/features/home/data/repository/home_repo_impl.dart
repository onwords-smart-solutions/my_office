import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../model/custom_punch_model.dart';
import '../model/staff_access_model.dart';
import '../data_source/home_fb_data_source.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeFbDataSource _homeFbDataSource;

  HomeRepoImpl(this._homeFbDataSource);

  @override
  Future<Either<ErrorResponse, List<UserEntity>>> getAllBirthday() async {
    return await _homeFbDataSource.getAllBirthday();
  }

  @override
  Future<Either<ErrorResponse, List<String>>>
      getInstallationMemberList() async {
    return await _homeFbDataSource.getInstallationMemberList();
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getManagementList() async {
    return await _homeFbDataSource.getManagementList();
  }

  @override
  Future<Either<ErrorResponse, CustomPunchModel?>> getPunchingTime(
    String staffId,
    String name,
    String department,
  ) async {
    return await _homeFbDataSource.getPunchingTime(staffId, name, department);
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getRNDTLList() async {
    return await _homeFbDataSource.getRNDTLList();
  }

  @override
  int getRandomNumber() {
    return _homeFbDataSource.getRandomNumber();
  }

  @override
  Future<Either<ErrorResponse, List<StaffAccessModel>>> getStaffAccess({
    required UserEntity staff,
  }) async {
    return await _homeFbDataSource.getStaffAccess(staff: staff);
  }

  @override
  Future<Either<ErrorResponse, List<UserEntity>>> getStaffDetails()async {
    return await _homeFbDataSource.getStaffDetails();
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getTLList() async{
    return await _homeFbDataSource.getTLList();
  }

  @override
  Future<Either<ErrorResponse, bool>> birthdaySubmitForm(context) async {
    return await _homeFbDataSource.birthdaySubmitForm(context);
  }

  @override
  Future<Either<ErrorResponse, bool>> phoneNumberSubmitForm(context) async{
    return await _homeFbDataSource.phoneNumberSubmitForm(context);
  }

}
