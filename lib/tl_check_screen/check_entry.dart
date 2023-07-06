import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_entry_model.dart';
import 'package:my_office/tl_check_screen/staff_entry_check.dart';
import 'package:shimmer/shimmer.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';
import '../util/screen_template.dart';

class CheckEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const CheckEntryScreen(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<CheckEntryScreen> createState() => _CheckEntryScreenState();
}

class _CheckEntryScreenState extends State<CheckEntryScreen> {
  List<StaffAttendanceModel> adminStaffNames = [];
  List<StaffAttendanceModel> staffList = [];
  List<String> attendanceTime = [];
  DateTime dateTime = DateTime.now();
  bool isLoading = true;
  final ref = FirebaseDatabase.instance.ref();
  final fingerPrint = FirebaseDatabase.instance.ref();
  final virtualAttendance = FirebaseDatabase.instance.ref();

  String dummy = 'All';
  final List<String> dropDown = ['All','Absentees', 'Late entry'];

  Future<void> staffDetails() async {
    adminStaffNames.clear();
    List<StaffAttendanceModel> fullEntry = [];
    await ref.child('staff').once().then((staffEntry) async {
      for (var data in staffEntry.snapshot.children) {
        var entry = data.value as Map<Object?, Object?>;
        // log('data is $entry');
        final staffEntry = StaffAttendanceModel(
          uid: data.key.toString(),
          department: entry['department'].toString(),
          name: entry['name'].toString(),
        );
        if (staffEntry.name != 'Nikhil Deepak') {
          adminStaffNames.add(staffEntry);
        }
      }
      for (var admin in adminStaffNames) {
        final time = await entryCheck(admin.uid);
        adminStaffNames
            .firstWhere((element) => element.uid == admin.uid)
            .entryTime = time;
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<String> entryCheck(String uid) async {
    String entryTime = '';
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    await fingerPrint
        .child('fingerPrint/$uid/$dateFormat')
        .once()
        .then((entry) async {
      if (entry.snapshot.value != null) {
        final data = entry.snapshot.value as Map<Object?, Object?>;
        var checkInTime = data.keys.toList();
        checkInTime.sort(
          (a, b) => a.toString().compareTo(
                b.toString(),
              ),
        );
        entryTime = checkInTime.first.toString();
        log('ENTRY TIME IS $entryTime');
      } else {
        entryTime = await checkVirtualAttendance(uid);
      }
    });
    return entryTime;
  }

  Future<String> checkVirtualAttendance(String uid) async {
    var yearFormat = DateFormat('yyyy').format(dateTime);
    var monthFormat = DateFormat('MM').format(dateTime);
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    String attendTime = '';
    await virtualAttendance
        .child('virtualAttendance/$uid/$yearFormat/$monthFormat/$dateFormat')
        .once()
        .then((virtual) {
      try {
        final data = virtual.snapshot.value as Map<Object?, Object?>;
        attendTime = data['Time'].toString();
      } catch (e) {
        log('error is $e');
      }
    });
    return attendTime;
  }

  @override
  void initState() {
    staffDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    staffList = adminStaffNames;
    return MainTemplate(
        subtitle: 'Check-in time',
        templateBody: checkEntry(),
        bgColor: ConstantColor.background1Color);
  }

  Widget checkEntry() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int present = 0;
    int absent = 0;

    //Sorting
    if (dummy == 'Late entry'){
     staffList = adminStaffNames.where((element){
       try {
         final time = element
             .entryTime
             .toString()
             .split(':');
         if (int.parse(time[0]) > 9 ||
             (int.parse(time[0]) == 9 &&
                 int.parse(time[1]) > 30)) {
          return true;
         }
       } catch (e) {
         print(e);
       }return false;
     }).toList();
    }else     if (dummy == 'Absentees'){
      staffList = adminStaffNames.where((element) => element.entryTime.toString().isEmpty).toList();
    }else{
      staffList = adminStaffNames;
    }

    for (var staff in staffList) {
      if (staff.entryTime!.isEmpty) {
        absent += 1;
      } else {
        present += 1;
      }
    }
    return isLoading
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, i) {
              return const Skeleton(
                height: 60,
              );
            },
          )
        : widget.staffName == 'Nikhil Deepak' ||
                widget.staffName == 'Devendiran' ||
                widget.staffName == 'Anitha' ||
                widget.staffName == 'Prem Kumar' ||
                widget.staffName == 'Koushik Romel' ||
                widget.staffName == 'Jibin K John' ||
                widget.staffName == 'Vinith' ||
                widget.staffName == 'Raam Kumar' ||
                widget.staffName == 'Ganesh'
            ? Column(
                children: [
                  Text(
                    'Present : $present',
                    style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        fontSize: 17,
                        color: ConstantColor.headingTextColor),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Absent : $absent',
                    style: TextStyle(
                        fontFamily: ConstantFonts.sfProBold,
                        fontSize: 17,
                        color: Colors.red),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // SizedBox(width: width * 0.75),
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          position: PopupMenuPosition.under,
                          elevation: 10,
                          itemBuilder: (ctx) => List.generate(
                            dropDown.length,
                            (i) {
                              return PopupMenuItem(
                                child: Text(
                                  dropDown[i],
                                  style: TextStyle(
                                      fontFamily: ConstantFonts.sfProMedium,
                                      fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    dummy = dropDown[i];
                                  });
                                },
                              );
                            },
                          ),
                          icon: const Icon(CupertinoIcons.sort_down),
                        ),
                        Text(
                          dummy,
                          style: TextStyle(
                              fontFamily: ConstantFonts.sfProRegular,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: staffList.length,
                      itemBuilder: (ctx, i) {
                        bool lateEntry = false;
                        try {
                          final time = staffList[i]
                              .entryTime
                              .toString()
                              .split(':');
                          if (int.parse(time[0]) > 9 ||
                              (int.parse(time[0]) == 9 &&
                                  int.parse(time[1]) > 30)) {
                            lateEntry = true;
                          }
                        } catch (e) {
                          print(e);
                        }
                        return Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: ConstantColor.background1Color,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0.0, 2.0),
                                blurRadius: 8,
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => StaffEntryCheckScreen(
                                    staffDetail: staffList[i],
                                  ),
                                ),
                              ),
                              leading: const CircleAvatar(
                                radius: 20,
                                child: Icon(CupertinoIcons.person_2_fill),
                              ),
                              title: Text(
                                staffList[i].name,
                                style: TextStyle(
                                    fontFamily: ConstantFonts.sfProMedium,
                                    color: ConstantColor.blackColor,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.021),
                              ),
                              trailing: Text(
                                staffList[i].entryTime.toString().isEmpty
                                    ? 'ABSENT'
                                    : staffList[i].entryTime.toString(),
                                style: TextStyle(
                                    fontFamily: ConstantFonts.sfProRegular,
                                    color: staffList[i]
                                            .entryTime
                                            .toString()
                                            .isEmpty
                                        ? CupertinoColors.destructiveRed
                                        : lateEntry
                                            ? Colors.orange
                                            : ConstantColor.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.020),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Lottie.asset('assets/animations/no_data.json', height: 300),
                  Center(
                    child: Text(
                      'No Entry Registered!!!',
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 20,
                        fontFamily: ConstantFonts.sfProRegular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ConstantColor.background1Color),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 55,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 40),
            Container(
              height: 55,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
