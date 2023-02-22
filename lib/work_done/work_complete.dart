// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Account/account_screen.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

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
                            // // print(element6.key);
                            // if(element6.key == 'totalWorkingTime'){
                            //   // for(var element7 in element6.children){
                            //   //   setState(() {
                            //   //     dayTotalWork.add(element7.value);
                            // //   //     print(dayTotalWork);
                            //   //   });
                            //   // }
                            // }
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
    return Scaffold(
      backgroundColor: ConstantColor.background1Color,
      body: Stack(
        children: [
          /// Top circle
          Positioned(
            top: height * 0.05,
            // left: width * 0.05,
            right: width * 0.05,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          AccountScreen(staffDetails: widget.userDetails)));
                });
              },
              child: const CircleAvatar(
                backgroundColor: ConstantColor.backgroundColor,
                radius: 20,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          ///Top Text...
          Positioned(
            top: height * 0.05,
            left: width * 0.05,
            // right: width*0.0,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Hi Admin\n',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.030,
                    ),
                  ),
                  TextSpan(
                    text: 'Staff Works Details',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.020,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: height * 0.18,
              left: width * 0.0,
              right: width * 0.0,
              bottom: height * 0.0,
              child: isLoading
                  ? Center(
                      child: Lottie.asset(
                        "assets/animations/loading.json",
                      ),
                    )
                  : nameData.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: nameData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.02),
                                decoration: BoxDecoration(
                                  color: ConstantColor.background1Color,
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.6),
                                      width: width * 0.008),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(-0.0, 3.0),
                                      blurRadius: 5,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        textWidget(
                                            height,
                                            '${nameData[index]}  ',
                                            height * 0.018),
                                      ],
                                    ),
                                    Container(
                                      height: height * 0.38,
                                      color: Colors.transparent,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            workDetailsContainer(
                                                height, width, index)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                        )
                      : Center(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontSize: height * 0.030,
                            ),
                          ),
                        )),

          /// Date Picker
          Positioned(
              top: height * 0.12,
              left: width * 0.58,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Widget workDetailsContainer(double height, double width, int index) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: allData.length,
        itemBuilder: (BuildContext context, int ind) {
          return allData[ind]['name'].contains(nameData[index])
              ? Container(
                  height: height * 0.25,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ConstantColor.background1Color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(-0.0, 0.0),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.02),
                          padding: const EdgeInsets.all(8),
                          height: height * 0.15,
                          width: width * 0.88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: ConstantColor.backgroundColor.withOpacity(0.09),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xffD136D4).withOpacity(0.09),
                                const Color(0xff7652B2).withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: textWidget(
                              height,
                              allData[ind]['workDone'],
                              height * 0.010,
                            ),
                          ),
                        ),
                        percentIndicator(
                          height,
                          double.parse(allData[ind]['workPercentage']
                                  .replaceAll(RegExp(r'.$'), "")) /
                              100,
                          allData[ind]['workPercentage'],
                          double.parse(allData[ind]['workPercentage']
                                      .replaceAll(RegExp(r'.$'), "")) <
                                  50
                              ? Colors.black
                              : ConstantColor.background1Color,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            textWidget(
                                height,
                                'Start : ${allData[ind]['from']}',
                                height * 0.010),
                            textWidget(height, 'End : ${allData[ind]['to']}',
                                height * 0.010),
                            textWidget(
                                height,
                                'Duration : ${allData[ind]['time_in_hours']}',
                                height * 0.010),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container();
        });
  }

  Widget percentIndicator(
      double height, double percent, String val, Color color) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.013,
      percent: percent,
      backgroundColor: Colors.black.withOpacity(0.05),
      // progressColor: Colors.cyan,
      linearGradient:
          const LinearGradient(colors: [Color(0xffD136D4), Color(0xff7652B2)]),
      center: Text(
        val,
        style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: color,
            fontSize: height * 0.010,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size,
          fontFamily: ConstantFonts.poppinsMedium,
          color: ConstantColor.blackColor),
    );
  }
}
