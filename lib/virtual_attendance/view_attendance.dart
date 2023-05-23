import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/virtual_attendance/view_full_attendance.dart';
import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';

class ViewAttendanceScreen extends StatefulWidget {
  const ViewAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  List<Map<Object?, Object?>> fullAttendance = [];
  final viewAttendance =
      FirebaseDatabase.instance.ref().child('virtualAttendance');

  DateTime now = DateTime.now();
  final today = DateTime.now();

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
    finalViewAttendance();
  }

  finalViewAttendance() {
    List<Map<Object?, Object?>> attendance = [];
    viewAttendance.once().then(
      (attendList) {
        for (var data in attendList.snapshot.children) {
          final newAttendance = data.value as Map<Object?, Object?>;
          Map<Object?, Object?> monthData = {};
          Map<Object?, Object?> dayData = {};
          Map<Object?, Object?> currentData = {};

          try {
            monthData = newAttendance[selectedYear] as Map<Object?, Object?>;
            dayData = monthData[selectedMonth] as Map<Object?, Object?>;
            currentData = dayData[selectedDate] as Map<Object?, Object?>;
          } catch (err) {
            err;
          }

          if (currentData.isNotEmpty) {
            attendance.add(currentData);
          }
        }
        setState(
          () {
            fullAttendance = attendance;
          },
        );
      },
    );
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    finalViewAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'View Attendance List!!',
        templateBody: viewAttendancePage(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewAttendancePage() {
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
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 17,
                  color: ConstantColor.backgroundColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        fullAttendance.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: fullAttendance.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewAllAttendance(
                                fullViewAttendance: fullAttendance[index]),
                          ),
                        );
                      },
                      leading: const CircleAvatar(
                        radius: 17,
                        backgroundColor: ConstantColor.backgroundColor,
                        child: Icon(Icons.person,size: 20,),
                      ),
                      title: Text(
                        fullAttendance[index]['Name'].toString(),
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: 16),
                      ),
                    );
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/animations/no_data.json',
                          height: 200.0),
                      Text(
                        'No Entry Registered',
                        style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          color: ConstantColor.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
