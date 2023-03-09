// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/work_done/individual_work_complete.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Account/account_screen.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class WorkCompleteViewScreen extends StatefulWidget {
  final StaffModel userDetails;

  const WorkCompleteViewScreen({Key? key, required this.userDetails})
      : super(key: key);

  @override
  State<WorkCompleteViewScreen> createState() => _WorkCompleteViewScreenState();
}

class _WorkCompleteViewScreenState extends State<WorkCompleteViewScreen> {
  final staff = FirebaseDatabase.instance.ref().child("staff");

  double percent = 0;
  bool isLoading = true;

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterDate.format(now);
    selectedYear = formatterDate.format(now);

    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      selectedMonth = newDate.toString().substring(5, 7);
      selectedYear = newDate.toString().substring(0, 4);
      if (selectedDate != null) {
        getWorkDetails();
      }
    });
  }

  List allData = [];
  List nameData = [];
  List nameList = [];
  List startTimeList = [];
  List endTimeList = [];
  List workDetailsList = [];
  List percentList = [];
  List totalTimeList = [];
  List workingHoursList = [];
  var fbData;

  getWorkDetails() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      // print('top  value $isLoading');
    });

    nameList.clear();
    startTimeList.clear();
    endTimeList.clear();
    workDetailsList.clear();
    percentList.clear();
    workingHoursList.clear();
    staff.once().then((value) {
      for (var element in value.snapshot.children) {
        for (var element1 in element.children) {
          if (element1.key == "workManager") {
            for (var element2 in element1.children) {
              for (var element3 in element2.children) {
                if (element3.key == selectedYear) {
                  for (var element4 in element3.children) {
                    if (element4.key == selectedMonth) {
                      for (var element5 in element4.children) {
                        if (element5.key == selectedDate) {
                          for (var element6 in element5.children) {
                            fbData = element6.value;
                            if (fbData['name'] != null) {
                              nameList.remove(fbData['name']);
                              if (!mounted) return;
                              setState(() {
                                allData.add(fbData);
                                nameData.add(fbData['name']);
                                nameData = nameData.toSet().toList();
                                nameList.add(fbData['name']);
                                startTimeList.add(fbData['to']);
                                endTimeList.add(fbData['from']);
                                workingHoursList.add(fbData['time_in_hours']);
                              });
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    getWorkDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
        subtitle: 'Staff Work Details',
        templateBody: buildStackWidget(height, width),
        bgColor: ConstantColor.background1Color);
  }


  Widget buildStackWidget(double height, double width) {
    List<Widget> workDoneNames = [];

    for (int i = 0; i < nameData.length; i++) {
      final widget = Container(
        // height: height * 0.1,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ConstantColor.background1Color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(-0.0, 5.0),
              blurRadius: 8,
            )
          ],
          borderRadius: BorderRadius.circular(11),
        ),
        child: Center(
          child: ListTile(
              onTap: () {
                var workDone;
                if (allData[i]['name'].contains(nameData[i])) {
                  workDone = allData[i]['workDone'];
                }
                workDone =
                    allData.where((element) => element['name'] == nameData[i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IndividualWorkDone(
                        workDetails: workDone.toList(),
                        employeeName: nameData[i]),
                  ),
                );
              },
              leading: const CircleAvatar(
                radius: 20,
                backgroundColor: ConstantColor.backgroundColor,
                child: Icon(Icons.person),
              ),
              title: Text(
                '${nameData[i]}',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.020),
              )),
        ),
      );

      workDoneNames.add(widget);
    }

    return isLoading
        ? Center(
      child: Lottie.asset(
        "assets/animations/loading.json",
      ),
    )
        : Column(
      children: [
        //calender button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$selectedDate   ',
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 15,
                      color: ConstantColor.blackColor)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    allData.clear();
                    nameData.clear();
                    datePicker();
                    getWorkDetails();
                  });
                },
                child: Image.asset(
                  'assets/calender.png',
                  scale: 3.3,
                ),
              ),
            ],
          ),
        ),
        nameData.isNotEmpty
            ? Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: workDoneNames),
          ),
        )
            : Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animations/no_data.json',
                  height: 250.0),
              Text(
                'No work done yet',
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  color: ConstantColor.blackColor,fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}