import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/home/domain/use_case/get_all_birthday_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_installation_members_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_management_list_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_punching_time_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_random_number_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_staff_access_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_staff_details_use_case.dart';
import 'package:my_office/features/home/domain/use_case/get_tl_list_use_case.dart';
import '../../../../core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../../data/model/custom_punch_model.dart';
import '../../data/model/staff_access_model.dart';

class HomeProvider extends ChangeNotifier {
  final GetAllBirthdayCase _getAllBirthdayCase;
  final GetInstallationMembersListCase _getInstallationMembersListCase;
  final GetManagementListCase _getManagementListCase;
  final GetPunchingTimeCase _getPunchingTimeCase;
  final GetRandomNumberCase _getRandomNumberCase;
  final GetStaffAccessCase _getStaffAccessCase;
  final GetStaffDetailsCase _getStaffDetailsCase;
  final GetTlListCase _getTlListCase;

  HomeProvider(this._getAllBirthdayCase,
      this._getTlListCase,
      this._getStaffDetailsCase,
      this._getStaffAccessCase,
      this._getRandomNumberCase,
      this._getPunchingTimeCase,
      this._getManagementListCase,
      this._getInstallationMembersListCase,
      );

  Future<Either<ErrorResponse, List<String>>> getManagementList() async =>
      await _getManagementListCase.execute();

  Future<Either<ErrorResponse, List<String>>> getTLList() async =>
      await _getTlListCase.execute();

  Future<Either<ErrorResponse, List<String>>>
  getInstallationMemberList() async =>
      await _getInstallationMembersListCase.execute();

  Future<Either<ErrorResponse, List<StaffAccessModel>>> getStaffAccess({
    required UserEntity staff,
  }) async =>
      await _getStaffAccessCase.execute(staff: staff);

  Future<CustomPunchModel?> getPunchingTime(
      String staffId,
      String name,
      String department,) async =>
      await _getPunchingTimeCase.execute(staffId, name, department);

  Future<Either<ErrorResponse, List<UserEntity>>> getAllBirthday() async =>
      await _getAllBirthdayCase.execute();

  Future<Either<ErrorResponse, List<UserEntity>>> getStaffDetails() async =>
      await _getStaffDetailsCase.execute();

  int getRandomNumber() => _getRandomNumberCase.execute();
}
