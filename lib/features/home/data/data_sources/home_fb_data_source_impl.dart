import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/home/data/data_sources/home_fb_data_source.dart';
import 'package:my_office/models/custom_punching_model.dart';
import 'package:my_office/models/staff_access_model.dart';
import 'package:my_office/models/staff_model.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

import '../../../../constant/app_defaults.dart';
import '../../../../provider/user_provider.dart';

class HomeFbDataSourceImpl implements HomeFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<Either<ErrorResponse, CustomPunchModel?>> getPunchingTime(
    String staffId,
    String name,
    String department,
  ) async {
    try {
      CustomPunchModel? punchDetail;
      bool isProxy = false;
      DateTime? checkInTime;
      DateTime? checkOutTime;
      String proxyInBy = '';
      String proxyOutBy = '';
      String proxyInReason = '';
      String proxyOutReason = '';

      String yearFormat = DateFormat('yyyy').format(DateTime.now());
      String monthFormat = DateFormat('MM').format(DateTime.now());
      String dateFormat = DateFormat('dd').format(DateTime.now());
      await FirebaseDatabase.instance
          .ref('attendance/$yearFormat/$monthFormat/$dateFormat/$staffId')
          .once()
          .then((value) async {
        if (value.snapshot.exists) {
          final attendanceData = value.snapshot.value as Map<Object?, Object?>;
          final checkIn = attendanceData['check_in'];
          final checkOut = attendanceData['check_out'];

          //check in time data
          if (checkIn != null) {
            checkInTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse(
                checkIn.toString().split(':')[0],
              ),
              int.parse(
                checkIn.toString().split(':')[1],
              ),
            );
            try {
              final proxyInByName =
                  attendanceData['proxy_in'] as Map<Object?, Object?>;
              proxyInBy = proxyInByName['proxy_by'].toString();
              final proxyInByReason =
                  attendanceData['proxy_in'] as Map<Object?, Object?>;
              proxyInReason = proxyInByReason['reason'].toString();
              isProxy = true;
            } catch (e) {
              dev.log('Check in exception is $e');
            }
          }

          //check out time data
          if (checkOut != null) {
            checkOutTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse(
                checkOut.toString().split(':')[0],
              ),
              int.parse(
                checkOut.toString().split(':')[1],
              ),
            );
            try {
              final proxyOutByName =
                  attendanceData['proxy_out'] as Map<Object?, Object?>;
              proxyOutBy = proxyOutByName['proxy_by'].toString();
              final proxyOutByReason =
                  attendanceData['proxy_out'] as Map<Object?, Object?>;
              proxyOutReason = proxyOutByReason['reason'].toString();
              isProxy = true;
            } catch (e) {
              dev.log('Check out exception is $e');
            }
          }

          punchDetail = CustomPunchModel(
            name: name,
            staffId: staffId,
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
      });
      return Right(punchDetail);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting checkTime $e',
          error: 'Unable to fetch checkTime of employees',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<StaffModel>>> getAllBirthday() async {
    try{
      List<StaffModel> bdayStaffs = [];
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
    }catch(e){
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting allBirthday $e',
          error: 'Unable to fetch birthday details',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getInstallationMemberList() async {
    List<String> names = [];
    try{
        await ref.child('special_access/installation').once().then((value) {
          if (value.snapshot.exists) {
            for (var user in value.snapshot.children) {
              names.add(user.value.toString());
            }
          }
        });
      return Right(names);
    }catch (e){
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
  Future<Either<ErrorResponse, List<String>>> getRNDTLList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/rnd_tl').once().then((value) {
        if (value.snapshot.exists) {
          for (var rndTl in value.snapshot.children) {
            names.add(rndTl.value.toString());
          }
        }
      });
      return Right(names);
    } catch (e) {
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting rndTlList $e',
          error: 'Unable to fetch rnd TL list',
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
    required StaffModel staff,
  }) async {
    try{
      List<StaffAccessModel> allAccess = [];

      final managementList = await getManagementList();
      final tlList = await getTLList();
      final rndTLList = await getRNDTLList();
      final installationList = await getInstallationMemberList();

      for (var menuItems in AppDefaults.allAccess) {
        //adding for management access
        if (managementList.right.contains(staff.name)) {
          if (menuItems.title == MenuTitle.createLead) {
            if (staff.uid == 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2') {
              allAccess.add(menuItems);
            }
          } else if (menuItems.title != MenuTitle.viewSuggestions ||
              menuItems.title != MenuTitle.staffDetail ||
              menuItems.title != MenuTitle.employeeOfTheWeek ||
              menuItems.title != MenuTitle.prDashboard) {
            allAccess.add(menuItems);
          }
        }

        //adding for tl access
        else if (tlList.right.contains(staff.name) || rndTLList.right.contains(staff.name)) {
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
              menuItems.title == MenuTitle.proxyAttendance ||
              menuItems.title == MenuTitle.scanQR) {
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
              menuItems.title == MenuTitle.installationEntry) {
            allAccess.add(menuItems);
          }
        }

        //adding for app and admin access
        else if (staff.department.toLowerCase() == 'admin' ||
            staff.department.toLowerCase() == 'app') {
          allAccess.add(menuItems);
        } else if (staff.department.toLowerCase() == 'pr') {
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
              menuItems.title == MenuTitle.quotationTemplate) {
            allAccess.add(menuItems);
          }
        } else {
          if (menuItems.title == MenuTitle.workEntry ||
              menuItems.title == MenuTitle.refreshment ||
              menuItems.title == MenuTitle.leavePortal ||
              menuItems.title == MenuTitle.suggestion) {
            allAccess.add(menuItems);
          }
        }
      }

      allAccess.sort((a, b) => a.title.compareTo(b.title));
      return Right(allAccess);
    }catch(e){
      return Left(
        ErrorResponse(
          metaInfo: 'Catch triggered in getting staffAccess $e',
          error: 'Unable to fetch staff access details',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, List<StaffModel>>> getStaffDetails() async {
    try{
      List<StaffModel> staffs = [];
      await FirebaseDatabase.instance.ref('staff').once().then((staff) async {
        for (var data in staff.snapshot.children) {
          var entry = data.value as Map<Object?, Object?>;
          final staffEntry = StaffModel(
            uid: data.key.toString(),
            department: entry['department'].toString(),
            name: entry['name'].toString(),
            email: entry['email'].toString(),
            uniqueId: '',
            profilePic: entry['profileImage'] == null
                ? ''
                : entry['profileImage'].toString(),
            dob: entry['dob'] == null ? 0 : int.parse(entry['dob'].toString()),
            phoneNumber: entry['mobile'] == null
                ? 0
                : int.parse(entry['mobile'].toString()),
          );

          staffs.add(staffEntry);
        }
      });
      return Right(staffs);
    }catch(e){
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
}
