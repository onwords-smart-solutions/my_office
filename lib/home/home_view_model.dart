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

  Future<List<StaffAccessModel>> getStaffAccess(
      {required StaffModel staff,}) async {
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
      String staffId, String name, String department,)
  async {
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
            isProxy=true;
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
            isProxy=true;
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
          phoneNumber: entry['phoneNumber'] == null ? 0 : int.parse(entry['phoneNumber'].toString()),
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
