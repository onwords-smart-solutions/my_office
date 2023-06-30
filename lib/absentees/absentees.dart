import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import 'package:intl/intl.dart';

import '../models/staff_entry_model.dart';

class AbsenteeScreen extends StatefulWidget {
  const AbsenteeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AbsenteeScreen> createState() => _AbsenteeScreenState();
}

class _AbsenteeScreenState extends State<AbsenteeScreen> {
  bool isLoading = true;
  List<StaffAttendanceModel> staffNames = [];
  List <StaffAttendanceModel> fullNames = [];
  final ref = FirebaseDatabase.instance.ref();
  final fingerPrint = FirebaseDatabase.instance.ref();
  final virtualAttendance = FirebaseDatabase.instance.ref();
  DateTime dateTime = DateTime.now();

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(
          () {
        selectedYear = formatterYear.format(newDate);
        selectedMonth = formatterMonth.format(newDate);
        selectedDate = formatterDate.format(newDate);
      },
    );
    staffDetails();
  }

  Future<void> staffDetails() async {
    staffNames.clear();
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
          staffNames.add(staffEntry);
        }
      }
      for (var admin in staffNames) {
        final time = await entryCheck(admin.uid);
        staffNames.firstWhere((element) => element.uid == admin.uid).entryTime =
            time;
      }
      if (!mounted) return;
      setState(() {
        fullNames = staffNames;
        isLoading = false;
      });
    });
  }

  Future<String> entryCheck(String uid) async {
    String entryName = '';
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    await fingerPrint
        .child('fingerPrint/$uid')
        .once()
        .then((entry) async {
     for(var name in entry.snapshot.children){
       final data = name.value as Map<Object?, Object?>;
       var entryName = data['name'].toString();
     }
     entryName = await checkVirtualAttendance(uid);
    });
    return entryName;
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
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    staffDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Absentees list!!',
        templateBody: bodyContent(),
        bgColor: ConstantColor.background1Color);
  }

  Widget bodyContent() {
    int absent = 0;
    for (var staff in staffNames) {
      if (staff.entryTime!.isEmpty) {
        absent += 1;
      }
    }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    datePicker();
                  },
                  child: Image.asset(
                    'assets/calender.png',
                    scale: 3,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  '$selectedDate',
                  style: TextStyle(
                    fontFamily: ConstantFonts.sfProBold,
                    fontSize: 17,
                    color: ConstantColor.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('Total absentees : $absent',
            style: TextStyle(
              fontSize: 17,
              fontFamily: ConstantFonts.sfProBold,
            ),
          ),
          isLoading
              ? Lottie.asset('assets/animations/new_loading.json')
              : staffNames.isNotEmpty
              ? Expanded(
            child: ListView.builder(
              itemCount: staffNames.length,
              itemBuilder: (ctx, i) {
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
                      leading: const CircleAvatar(
                        radius: 20,
                        child: Icon(CupertinoIcons.person_2_fill),
                      ),
                      title: Text(
                        staffNames[i].name,
                        style: TextStyle(
                            fontFamily: ConstantFonts.sfProMedium,
                            color: ConstantColor.blackColor,
                            fontSize:
                            MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.021),
                      ),
                      trailing: Text(
                        staffNames[i].department,
                        style: TextStyle(
                            fontFamily: ConstantFonts.sfProBold,
                            color: CupertinoColors.destructiveRed,
                            fontSize:
                            MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.021),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
              : Expanded(
            child: Center(
              child: Column(
                children: [
                  Lottie.asset('assets/animations/no_data.json',
                      height: 300),
                  Text(
                    'Everyone is Present today🤔',
                    style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 20,
                      fontFamily: ConstantFonts.sfProRegular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
