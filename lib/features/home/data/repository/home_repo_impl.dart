import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';
import '../../../user/data/model/user_model.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../model/custom_punch_model.dart';
import '../model/employee_of_the_week_model.dart';
import '../model/staff_access_model.dart';
import '../data_source/home_fb_data_source.dart';
import 'dart:developer' as dev;

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
  Future<Either<ErrorResponse, List<UserEntity>>> getStaffDetails() async {
    return await _homeFbDataSource.getStaffDetails();
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getTLList() async {
    return await _homeFbDataSource.getTLList();
  }

  @override
  Future<CustomPunchModel?> checkTime(
    String staffId,
    String name,
    String department,
  ) async {
    CustomPunchModel? punchDetail;
    DateTime currentDate = DateTime.now();
    final attendanceData = await _homeFbDataSource.fetchAttendanceData(staffId, currentDate);

    if (attendanceData != null) {
      DateTime? checkInTime;
      DateTime? checkOutTime;
      String proxyInBy = '';
      String proxyOutBy = '';
      String proxyInReason = '';
      String proxyOutReason = '';
      bool isProxy = false;

      final checkIn = attendanceData['check_in'];
      final checkOut = attendanceData['check_out'];

      // Process check-in time data
      if (checkIn != null) {
        checkInTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          int.parse(checkIn.toString().split(':')[0]),
          int.parse(checkIn.toString().split(':')[1]),
        );

        try {
          final proxyInByName = attendanceData['proxy_in'] as Map<Object?, Object?>;
          proxyInBy = proxyInByName['proxy_by'].toString();
          final proxyInByReason = attendanceData['proxy_in'] as Map<Object?, Object?>;
          proxyInReason = proxyInByReason['reason'].toString();
          isProxy = true;
        } catch (e) {
          dev.log('Check in exception is $e');
        }
      }

      // Process check-out time data
      if (checkOut != null) {
        checkOutTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          int.parse(checkOut.toString().split(':')[0]),
          int.parse(checkOut.toString().split(':')[1]),
        );

        try {
          final proxyOutByName = attendanceData['proxy_out'] as Map<Object?, Object?>;
          proxyOutBy = proxyOutByName['proxy_by'].toString();
          final proxyOutByReason = attendanceData['proxy_out'] as Map<Object?, Object?>;
          proxyOutReason = proxyOutByReason['reason'].toString();
          isProxy = true;
        } catch (e) {
          dev.log('Check out exception is $e');
        }
      }

      // Create and return the CustomPunchModel
      punchDetail = CustomPunchModel(
        staffId: staffId,
        name: name,
        department: department,
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        checkInProxyBy: proxyInBy,
        checkInReason: proxyInReason,
        checkOutProxyBy: proxyOutBy,
        checkOutReason: proxyOutReason,
        isProxy: isProxy,
      );
    }

    return punchDetail;
  }

  @override
  Future<Map<Object?, Object?>> checkAppVersion() async {
    return _homeFbDataSource.getAppVersionInfo();
  }

  @override
  Future<EmployeeOfWeekData> getEmployeeOfTheWeek() async {
    try {
      final employeeOfWeekData = await _homeFbDataSource.getEmployeeOfWeek();
      final uid = employeeOfWeekData['person'].toString();
      final reason = employeeOfWeekData['reason'].toString();

      if (uid != 'null' && uid.isNotEmpty) {
        final staffDetails = await _homeFbDataSource.getAllStaffDetails(uid);
        final employee =  UserModel(
          uid: uid,
          name: staffDetails['name'].toString(),
          dep: staffDetails['department'].toString(),
          email: staffDetails['email'].toString(),
          url: staffDetails['profileImage'].toString(),
          dob: staffDetails['dob'] == null ? 0 : int.parse(staffDetails['dob'].toString()),
          mobile: staffDetails['mobile'] == null ? 0 : int.parse(staffDetails['mobile'].toString()),
          uniqueId: '',
        );
        return EmployeeOfWeekData(employee: employee, reason: reason);
      } else {
        throw Exception('No valid employee of the week');
      }
    } catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity?> salesData(String userId) {
    return _homeFbDataSource.salesData(userId);
  }
}
