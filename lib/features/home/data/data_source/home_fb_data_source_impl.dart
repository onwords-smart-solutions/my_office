import 'dart:math';
import 'dart:developer' as dev;
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import '../../../../core/utilities/constants/app_default_screens.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../model/staff_access_model.dart';
import 'home_fb_data_source.dart';

class HomeFbDataSourceImpl implements HomeFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<Either<ErrorResponse, List<UserEntity>>> getAllBirthday() async {
    try {
      List<UserEntity> bdayStaffs = [];
      final today = DateTime.now();
      final allStaff = await getStaffDetails();
      for (var staff in allStaff.right) {
        if (staff.dob != 0) {
          final staffBirthday = DateTime.fromMillisecondsSinceEpoch(staff.dob);
          if (staffBirthday.month == today.month &&
              staffBirthday.day == today.day) {
            bdayStaffs.add(staff);
          }
        }
      }
      return Right(bdayStaffs);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting allBirthday $e',
          error: 'Unable to fetch birthday details',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<String>>>
  getInstallationMemberList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/installation').once().then((value) {
        if (value.snapshot.exists) {
          for (var user in value.snapshot.children) {
            names.add(user.value.toString());
          }
        }
      });
      return Right(names);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting installationMembersList $e',
          error: 'Unable to fetch installation names',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getManagementList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/management').once().then((value) {
        if (value.snapshot.exists) {
          for (var mgmt in value.snapshot.children) {
            names.add(mgmt.value.toString());
          }
        }
      });
      return Right(names);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting managementList $e',
          error: 'Unable to fetch management staff names',
        ),
      );
    }
  }

  @override
  int getRandomNumber() {
    Random random = Random();
    return random
        .nextInt(44); // Generates a random number from 0 to 44 (inclusive).
  }

  @override
  Future<Either<ErrorResponse, List<StaffAccessModel>>> getStaffAccess({
    required UserEntity staff,
  }) async {
    try {
      List<StaffAccessModel> allAccess = [];
      final managementList = await getManagementList();
      final tlList = await getTLList();
      final installationList = await getInstallationMemberList();

      for (var menuItems in AppDefaults.allAccess) {
        //adding for management access
        if (managementList.right.contains(staff.name)) {
          if (menuItems.title == MenuTitle.createLead ||
              menuItems.title == MenuTitle.prDashboard) {
            if (staff.uid == 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2') {
              allAccess.add(menuItems);
            }
          } else if (menuItems.title == MenuTitle.proxyAttendance) {
            if (staff.uid == 'pztngdZPCPQrEvmI37b3gf3w33d2' ||
                staff.uid == 'x7RbfotHBpfr7JZ88P9eABWtcQM2' ||
                staff.uid == '5cM1kyNARSS3yKiO8EB0o1E9eiA3') {
              allAccess.add(menuItems);
            }
          } else if (menuItems.title == MenuTitle.saleCount) {
            if (staff.uid == 'pztngdZPCPQrEvmI37b3gf3w33d2' ||
                staff.uid == 'x7RbfotHBpfr7JZ88P9eABWtcQM2') {
              allAccess.add(menuItems);
            }
          }
          else if (menuItems.title != MenuTitle.viewSuggestions &&
              menuItems.title != MenuTitle.staffDetail &&
              menuItems.title != MenuTitle.employeeOfTheWeek &&
              menuItems.title != MenuTitle.prDashboard &&
              menuItems.title != MenuTitle.proxyAttendance) {
            allAccess.add(menuItems);
          }
        }
        //adding for tl access
        else if (tlList.right.contains(staff.name)) {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.workDetail ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.searchLead ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.attendance ||
              menuItems.title == MenuTitle.createInvoice ||
              menuItems.title == MenuTitle.leaveApproval ||
              menuItems.title == MenuTitle.quotationTemplate ||
              menuItems.title == MenuTitle.installationPDF ||
              menuItems.title == MenuTitle.scanQR ||
              menuItems.title == MenuTitle.paySlip) {
            allAccess.add(menuItems);
          }
        }
        //adding for installation access
        else if (installationList.right.contains(staff.name)) {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.createInvoice ||
              menuItems.title == MenuTitle.quotationTemplate ||
              menuItems.title == MenuTitle.installationPDF ||
              menuItems.title == MenuTitle.paySlip) {
            allAccess.add(menuItems);
          }
        }
        //adding for app and admin access
        else if (staff.dep.toLowerCase() == 'admin' ||
            staff.dep.toLowerCase() == 'app') {
          allAccess.add(menuItems);
        }
        // //restricting pr limited access to Solar account
        // else if(staff.dep.toLowerCase() == 'pr' && staff.uid == 'ajckJI82Y4Uk6780vpSMmyo3ylr2'){
        //   if(menuItems.title == MenuTitle.searchLead ||
        //       menuItems.title == MenuTitle.createInvoice){
        //     allAccess.add(menuItems);
        //   }
        // }
        //adding for pr access
        else if (staff.dep.toLowerCase() == 'pr') {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.searchLead ||
              menuItems.title == MenuTitle.prVisit ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.createInvoice ||
              menuItems.title == MenuTitle.prWorkDone ||
              menuItems.title == MenuTitle.salesPoint ||
              menuItems.title == MenuTitle.scanQR ||
              menuItems.title == MenuTitle.prReminder ||
              menuItems.title == MenuTitle.quotationTemplate ||
              menuItems.title == MenuTitle.paySlip) {
            allAccess.add(menuItems);
          }
        }
        //adding for office staff access
        else if (staff.dep.toLowerCase() == 'office staff') {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.paySlip ||
              menuItems.title == MenuTitle.foodCount ||
              menuItems.title == MenuTitle.createInvoice ||
              menuItems.title == MenuTitle.quotationTemplate ||
              menuItems.title == MenuTitle.attendance) {
            allAccess.add(menuItems);
          }
        }
        //adding access for lokesh
        else if (staff.uid == 'lloBhjn2aSRijD33pDeH5Bn2aJD3') {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.searchLead ||
              menuItems.title == MenuTitle.prVisit ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.createInvoice ||
              menuItems.title == MenuTitle.prWorkDone ||
              menuItems.title == MenuTitle.salesPoint ||
              menuItems.title == MenuTitle.scanQR ||
              menuItems.title == MenuTitle.prReminder ||
              menuItems.title == MenuTitle.quotationTemplate ||
              menuItems.title == MenuTitle.paySlip ||
              menuItems.title == MenuTitle.saleCount) {
            allAccess.add(menuItems);
          }
        }
        //adding access for bravo
        else if (staff.dep.toLowerCase() == 'bravo') {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.searchLead ||
              menuItems.title == MenuTitle.prVisit ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.createInvoice ||
              menuItems.title == MenuTitle.prWorkDone ||
              menuItems.title == MenuTitle.salesPoint ||
              menuItems.title == MenuTitle.scanQR ||
              menuItems.title == MenuTitle.prReminder ||
              menuItems.title == MenuTitle.quotationTemplate ||
              menuItems.title == MenuTitle.paySlip ||
              menuItems.title == MenuTitle.attendance ||
              menuItems.title == MenuTitle.foodCount) {
            allAccess.add(menuItems);
          }
        }
        //adding access for everyone
        else {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.suggestion ||
              menuItems.title == MenuTitle.paySlip) {
            allAccess.add(menuItems);
          }
        }
      }

      allAccess.sort((a, b) => a.title.compareTo(b.title));
      return Right(allAccess);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting staffAccess $e',
          error: 'Unable to fetch staff access details',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<UserEntity>>> getStaffDetails() async {
    try {
      List<UserEntity> staffs = [];
      await FirebaseDatabase.instance.ref('staff').once().then((staff) async {
        for (var data in staff.snapshot.children) {
          var entry = data.value as Map<Object?, Object?>;
          final staffEntry = UserEntity(
            uid: data.key.toString(),
            dep: entry['department'].toString(),
            name: entry['name'].toString(),
            email: entry['email'].toString(),
            url: entry['profileImage'] == null
                ? ''
                : entry['profileImage'].toString(),
            dob: entry['dob'] == null ? 0 : int.parse(entry['dob'].toString()),
            mobile: entry['mobile'] == null
                ? 0
                : int.parse(entry['mobile'].toString()),
            uniqueId: '',
            saleAchieved: entry['leads_achieved'].toString(),
            saleTarget: entry['leads_target'].toString(),
          );
          staffs.add(staffEntry);
        }
      });
      return Right(staffs);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting staffDetails $e',
          error: 'Unable to fetch staff details',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getTLList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/tl').once().then((value) {
        if (value.snapshot.exists) {
          for (var tl in value.snapshot.children) {
            names.add(tl.value.toString());
          }
        }
      });
      return Right(names);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting tlList $e',
          error: 'Unable to fetch TL list names',
        ),
      );
    }
  }

  @override
  Future<Map<Object?, Object?>?> fetchAttendanceData(String staffId,
      DateTime date,) async {
    String yearFormat = DateFormat('yyyy').format(date);
    String monthFormat = DateFormat('MM').format(date);
    String dateFormat = DateFormat('dd').format(date);

    final attendanceRef =
    ref.child('attendance/$yearFormat/$monthFormat/$dateFormat/$staffId');
    DatabaseEvent event = await attendanceRef.once();

    if (event.snapshot.exists) {
      return event.snapshot.value as Map<Object?, Object?>?;
    }
    return null;
  }

  @override
  Future<Map<Object?, Object?>> getAppVersionInfo() async {
    final snapshot = await ref.child('myOffice').once();
    if (snapshot.snapshot.exists) {
      return snapshot.snapshot.value as Map<Object?, Object?>;
    }
    throw Exception("Data not found");
  }

  @override
  Future<Map<Object?, Object?>> getEmployeeOfWeek() async {
    final snapshot = await ref.child('PRDashboard/employee_of_week').once();
    if (snapshot.snapshot.exists) {
      return snapshot.snapshot.value as Map<Object?, Object?>;
    }
    throw Exception('Employee of the week data not found');
  }

  @override
  Future<Map<Object?, Object?>> getAllStaffDetails(String uid) async {
    final snapshot = await ref.child('staff/$uid').once();
    return snapshot.snapshot.value as Map<Object?, Object?>;
  }

  @override
  Future<UserEntity?> salesData(String userId) async {
    try {
      UserEntity? result;
      await FirebaseDatabase.instance.ref('staff/$userId').once().then((staff) async {
        if(staff.snapshot.exists){
          var entry = staff.snapshot.value as Map<Object?, Object?>;
          final staffEntry = UserEntity(
            uid: userId,
            dep: entry['department'].toString(),
            name: entry['name'].toString(),
            email: entry['email'].toString(),
            url: entry['profileImage'] == null
                ? ''
                : entry['profileImage'].toString(),
            dob: entry['dob'] == null ? 0 : int.parse(entry['dob'].toString()),
            mobile: entry['mobile'] == null
                ? 0
                : int.parse(entry['mobile'].toString()),
            uniqueId: '',
            saleAchieved: entry['leads_achieved'].toString(),
            saleTarget: entry['leads_target'].toString(),
          );
          result = UserEntity(
            uid: staffEntry.uid,
            dep: staffEntry.dep,
            email: staffEntry.email,
            name: staffEntry.name,
            dob: staffEntry.dob,
            mobile: staffEntry.mobile,
            url: staffEntry.url,
            uniqueId: staffEntry.uniqueId,
            saleTarget: staffEntry.saleTarget,
            saleAchieved: staffEntry.saleAchieved,
          );
        }
        });
      return result;
    } catch (e) {
      print('Error caught while getting PR sale data: $e');
      rethrow;
    }
  }
}
