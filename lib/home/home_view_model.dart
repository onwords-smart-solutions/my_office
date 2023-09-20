import 'dart:developer' as dev;
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_office/constant/app_defaults.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/custom_punching_model.dart';
import '../models/staff_access_model.dart';

class HomeViewModel {
  final ref = FirebaseDatabase.instance.ref();

  Future<List<String>> getManagementList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/management').once().then((value) {
        if (value.snapshot.exists) {
          for (var mgmt in value.snapshot.children) {
            names.add(mgmt.value.toString());
          }
        }
      });
    } catch (e) {
      dev.log('Error from getting management names $e');
    }
    return names;
  }

  Future<List<String>> getTLList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/tl').once().then((value) {
        if (value.snapshot.exists) {
          for (var tl in value.snapshot.children) {
            names.add(tl.value.toString());
          }
        }
      });
    } catch (e) {
      dev.log('Error from getting TL names $e');
    }
    return names;
  }

  Future<List<String>> getRNDTLList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/rnd_tl').once().then((value) {
        if (value.snapshot.exists) {
          for (var rndTl in value.snapshot.children) {
            names.add(rndTl.value.toString());
          }
        }
      });
    } catch (e) {
      dev.log('Error from getting rndTl names $e');
    }
    return names;
  }

  Future<List<String>> getInstallationMemberList() async {
    List<String> names = [];
    try {
      await ref.child('special_access/installation').once().then((value) {
        if (value.snapshot.exists) {
          for (var user in value.snapshot.children) {
            names.add(user.value.toString());
          }
        }
      });
    } catch (e) {
      dev.log('Error from getting installation names $e');
    }
    return names;
  }

  Future<List<StaffAccessModel>> getStaffAccess({
    required StaffModel staff,
  }) async {
    List<StaffAccessModel> allAccess = [];

    final managementList = await getManagementList();
    final tlList = await getTLList();
    final rndTLList = await getRNDTLList();
    final installationList = await getInstallationMemberList();

    for (var menuItems in AppDefaults.allAccess) {
      //adding for management access
      if (managementList.contains(staff.name)) {
        if (menuItems.title == MenuTitle.createLead) {
          if (staff.uid == 'ZIuUpLfSIRgRN5EqP7feKA9SbbS2') {
            allAccess.add(menuItems);
          }
        } else if (menuItems.title != MenuTitle.viewSuggestions ||
            menuItems.title != MenuTitle.staffDetail) {
          allAccess.add(menuItems);
        }
      }

      //adding for tl access
      else if (tlList.contains(staff.name) || rndTLList.contains(staff.name)) {
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
      else if (installationList.contains(staff.name)) {
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
    return allAccess;
  }

  Future<CustomPunchModel> getPunchingTime(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = await _checkTime(
      userProvider.user!.uid,
      userProvider.user!.name,
      userProvider.user!.department,
    );
    if (data != null) {
      return data;
    } else {
      return CustomPunchModel(
        staffId: userProvider.user!.uid,
        name: userProvider.user!.name,
        department: userProvider.user!.department,
        checkInTime: null,
      );
    }
  }

  Future<CustomPunchModel?> _checkTime(
    String staffId,
    String name,
    String department,
  ) async {
    CustomPunchModel? punchDetail;
    final today = DateTime.now();
    bool isProxy = false;
    DateTime? checkInTime;
    DateTime? checkOutTime;

    String dateFormat = DateFormat('yyyy-MM-dd').format(today);
    await FirebaseDatabase.instance
        .ref('fingerPrint/$staffId/$dateFormat')
        .once()
        .then((value) async {
      if (value.snapshot.exists) {
        List<DateTime> allPunchedTime = [];
        for (var tapTime in value.snapshot.children) {
          String? tapTimeString = tapTime.key;
          if (tapTimeString != null) {
            //spitting time based on colon
            final timeList = tapTimeString.split(':');

            //converting splitted time into datetime format
            final tapTimeDateFormat = DateTime(
              today.year,
              today.month,
              today.day,
              int.parse(timeList[0]),
              int.parse(timeList[1]),
              int.parse(timeList[2]),
            );
            allPunchedTime.add(tapTimeDateFormat);
          }
        }
        // checking for check in and check out time
        if (allPunchedTime.isNotEmpty) {
          allPunchedTime.sort();
          checkInTime = allPunchedTime.first;
          if (allPunchedTime.length > 1) {
            if (allPunchedTime.last.difference(checkInTime!).inMinutes > 5) {
              checkOutTime = allPunchedTime.last;
            }
          }
        }
      }
    });
    //check in proxy attendance
    final punchDetailFromProxy =
        await _checkProxyEntry(staffId, dateFormat, department);

    if (punchDetailFromProxy != null) {
      // check in time
      if (punchDetailFromProxy.checkInTime != null) {
        if (checkInTime == null) {
          checkInTime = punchDetailFromProxy.checkInTime;
          isProxy = true;
        } else {
          final check =
              checkInTime!.compareTo(punchDetailFromProxy.checkInTime!);
          if (check == 1) {
            if (checkOutTime == null) {
              if (checkInTime!
                      .difference(punchDetailFromProxy.checkInTime!)
                      .inMinutes >
                  5) {
                checkOutTime = checkInTime;
              }
            }

            checkInTime = punchDetailFromProxy.checkInTime!;
            isProxy = true;
          }
        }
      }

      //check out time
      if (punchDetailFromProxy.checkOutTime != null) {
        if (checkOutTime == null) {
          checkOutTime = punchDetailFromProxy.checkOutTime;
          isProxy = true;
        } else {
          final check =
              checkOutTime!.compareTo(punchDetailFromProxy.checkOutTime!);
          if (check == -1) {
            checkOutTime = punchDetailFromProxy.checkOutTime!;
            isProxy = true;
          }
        }
      }
    }

    punchDetail = CustomPunchModel(
      name: name,
      staffId: staffId,
      department: department,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      isProxy: isProxy,
    );
    return punchDetail;
  }

  Future<CustomPunchModel?> _checkProxyEntry(
    String staffId,
    String dateFormat,
    String department,
  ) async {
    CustomPunchModel? punchDetail;
    await FirebaseDatabase.instance
        .ref('proxy_attendance/$staffId/$dateFormat')
        .once()
        .then((proxy) async {
      if (proxy.snapshot.exists) {
        Map<Object?, Object?> checkInDetail = {};
        Map<Object?, Object?> checkOutDetail = {};
        if (proxy.snapshot.child('Check-in').exists) {
          checkInDetail =
              proxy.snapshot.child('Check-in').value as Map<Object?, Object?>;
        }
        if (proxy.snapshot.child('Check-out').exists) {
          checkOutDetail =
              proxy.snapshot.child('Check-out').value as Map<Object?, Object?>;
        }

        punchDetail = CustomPunchModel(
          name: checkInDetail['Name'].toString(),
          staffId: staffId,
          department: department,
          checkInTime: checkInDetail.isEmpty
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(checkInDetail['Time'].toString()),
                ),
          checkOutTime: checkOutDetail.isEmpty
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(checkOutDetail['Time'].toString()),
                ),
          checkInProxyBy: checkInDetail['Proxy'].toString(),
          checkInReason: checkInDetail['Reason'].toString(),
          checkOutProxyBy:
              checkOutDetail.isEmpty ? '' : checkOutDetail['Name'].toString(),
          checkOutReason:
              checkOutDetail.isEmpty ? '' : checkOutDetail['Reason'].toString(),
          isProxy: true,
        );
      }
    });
    return punchDetail;
  }

  Future<List<StaffModel>> getAllBirthday() async {
    List<StaffModel> bdayStaffs = [];
    final today = DateTime.now();
    final allStaff = await _getStaffDetails();
    for (var staff in allStaff) {
      if (staff.dob != 0) {
        final staffBirthday = DateTime.fromMillisecondsSinceEpoch(staff.dob);
        if (staffBirthday.month == today.month &&
            staffBirthday.day == today.day) {
          bdayStaffs.add(staff);
        }
      }
    }
    return bdayStaffs;
  }

  Future<List<StaffModel>> _getStaffDetails() async {
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
        );

        staffs.add(staffEntry);
      }
    });
    return staffs;
  }

  int getRandomNumber() {
    Random random = Random();
    return random
        .nextInt(44); // Generates a random number from 0 to 44 (inclusive).
  }
}
