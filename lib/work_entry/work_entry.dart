// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:my_office/util/main_template.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class WorkEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const WorkEntryScreen(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<WorkEntryScreen> createState() => _WorkEntryScreenState();
}

class _WorkEntryScreenState extends State<WorkEntryScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  final staff = FirebaseDatabase.instance.ref().child("staff");

  final fingerPrint = FirebaseDatabase.instance.ref().child("fingerPrint");

  final TextEditingController _workController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int above6 = 0;

  double percent = 0;
  bool isLoading = false;

  var formattedDate;
  var formattedMonth;
  var formattedYear;
  String? formattedTime;

  todayDate() {
    var now = DateTime.now();

    var formatterDate = DateFormat('yyy-MM-dd');
    var formatterYear = DateFormat('yyy');
    var formatterMonth = DateFormat('MM');
    formattedTime = DateFormat('HH:mm').format(now);
    formattedDate = formatterDate.format(now);
    formattedYear = formatterYear.format(now);
    formattedMonth = formatterMonth.format(now);
  }

  String? currentUser;
  var fbData;
  var totalWorkingTime;
  List nameList = [];
  List endTimeList = [];
  List startTimeList = [];
  List workDoneList = [];
  List workPercentageList = [];
  List workingHoursList = [];

  getWorkDone() {
    nameList.clear();
    workingHoursList.clear();
    startTimeList.clear();
    endTimeList.clear();
    workPercentageList.clear();
    workDoneList.clear();
    staff
        .child(
        "${widget.userId}/workManager/timeSheet/$formattedYear/$formattedMonth/$formattedDate")
        .once()
        .then((value) {
      for (var loop in value.snapshot.children) {
        fbData = loop.value;
        if (!mounted) return;
        setState(() {
          startTimeList.add(fbData['from']);
          endTimeList.add(fbData['to']);
          workPercentageList.add(fbData['workPercentage']);
          workDoneList.add(fbData['workDone']);
          workingHoursList.add(fbData['time_in_hours']);
        });
      }
    });
  }

  var timeDifference;
  String? timeOfStart = '';
  String? timeOfEnd = '';
  String? percentage = '';
  String? timeOfStartView = '';
  String? timeOfEndView = '';
  String? from;
  String? to;
  var wrkDone;

  createNewWork() {
    staff
        .child(
        "${widget.userId}/workManager/timeSheet/$formattedYear/$formattedMonth/$formattedDate/${timeOfStart.toString().trim()} to ${timeOfEnd.toString().trim()}")
        .set({
      "from": timeOfStart.toString().trim(),
      "to": timeOfEnd.toString().trim(),
      "workDone": _workController.text.toString().trim(),
      "workPercentage": "${_percentController.text.toString().trim()}%",
      'name': widget.staffName.toString().trim(),
      'time_in_hours': totalWorkingTime.toString(),
    }).then((value) {
      timeOfStart = '';
      timeOfEnd = '';
      timeOfStartView = '';
      timeOfEndView = '';
      _workController.clear();
      _percentController.clear();
      getWorkDone();
      showSnackBar(message: 'Work updated successfully', color: Colors.green);
      isLoading = false;
    });
  }

  startTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (!mounted) return;
    if (pickedTime != null) {
      DateTime parsedTime =
      DateFormat.jm().parse(pickedTime.format(context).toString());

      ///converting to DateTime so that we can further format on different pattern.
      String formattedTime = DateFormat('HH:mm').format(parsedTime);

      ///DateFormat() is from intl package, you can format the time on any pattern you need.

      setState(() {
        timeOfStart = formattedTime;
        timeOfStartView = DateFormat.jm()
            .format(DateFormat("hh:mm:ss").parse("$formattedTime:00"));
      });
    }
  }

  endTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (!mounted) return;
    if (pickedTime != null) {
      DateTime parsedTime =
      DateFormat.jm().parse(pickedTime.format(context).toString());

      ///converting to DateTime so that we can further format on different pattern.
      // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      String formattedTime = DateFormat('HH:mm').format(parsedTime);

      ///DateFormat() is from intl package, you can format the time on any pattern you need.
      setState(() {
        timeOfEnd = formattedTime;
        timeOfEndView = DateFormat.jm()
            .format(DateFormat("hh:mm:ss").parse("$formattedTime:00"));
      });
    } else {
      // print("Time is not selected");
    }
  }

  bool a = true;
  bool b = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    todayDate();
    getWorkDone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
      key: formKey,
      subtitle: 'Update your works here !',
      templateBody: bodyContent(height, width),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget bodyContent(double height, double width) {
    return Stack(
      children: [
        Positioned(
          top: height * 0.0,
          left: width * 0.0,
          right: width * 0.0,
          bottom: height * 0.0,
          child: Stack(
            children: [
              /// TabBar...
              Positioned(
                top: height * 0.01,
                left: width * 0.05,
                right: width * 0.05,
                // bottom: height * 0.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      height: height * 0.08,
                      decoration: const BoxDecoration(
                        // color: ConstantColor.background1Color,
                        gradient: LinearGradient(
                            colors: [
                              Color(0xffD136D4),
                              Color(0xff7652B2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft),
                      ),
                      child: tabBarContainer(height, width),
                    ),
                  ),
                ),
              ),

              /// TabBarView...
              Positioned(
                top: height * 0.13,
                left: width * 0.01,
                right: width * 0.01,
                bottom: height * 0.0,
                child: tabViewContainer(height, width),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tabBarContainer(double height, double width) {
    return TabBar(
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      indicator: BoxDecoration(
        // color: Color(0xffDDE6E8),
          gradient: const LinearGradient(
              colors: [
                Color(0xffD136D4),
                Color(0xff7652B2),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(10.0)),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black.withOpacity(0.5),
      automaticIndicatorColorAdjustment: true,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w800, fontFamily: ConstantFonts.poppinsMedium),
      tabs: [
        Container(
          height: height * 0.05,
          width: width * 0.3,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Center(child: Text('Work Entry')),
        ),
        Container(
          height: height * 0.05,
          width: width * 0.3,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Center(child: Text('Work History')),
        ),
      ],
    );
  }

  Widget tabViewContainer(double height, double width) {
    return SizedBox(
      height: height * 0.9,
      // color: Colors.transparent,
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        children: [
          /// First Screen
          tabBarViewFirstScreen(height, width),

          /// Second Screen
          tabBarViewSecondScreen(height, width),
        ],
      ),
    );
  }

  Widget tabBarViewFirstScreen(double height, double width) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(08),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Text Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildNeumorphic(
                width,height,10, Container(
                child: textFiledWidget(
                    height,
                    TextInputType.text,
                    TextInputAction.done,
                    'Enter work details',
                    _workController),
              ),
              ),
            ),

            /// 3 Buttons
            Padding(
              padding: EdgeInsets.only(top: height * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNeumorphic(
                    width,height,10, ButtonWidget(
                      title: 'Start Time',
                      onClicked: () {
                        startTime();
                      },
                      colorValue: timeOfStart.toString().isEmpty
                          ? a = false
                          : a = true,
                      icon: const Icon(Icons.alarm,color: Colors.black,),
                      val:
                      "${timeOfStartView!.isEmpty ? '--' : timeOfStartView}"),
                  ),
                  buildNeumorphic(
                    width,height,10, ButtonWidget(
                      title: 'End Time',
                      onClicked: () {
                        endTime();
                      },
                      colorValue: timeOfEnd.toString().isEmpty
                          ? b = false
                          : b = true,
                      icon: const Icon(Icons.alarm,color: Colors.black,),
                      val:
                      "${timeOfEndView!.isEmpty ? '--' : timeOfEndView}"),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          headerAnimationLoop: false,
                          // dialogType: DialogType.success,
                          customHeader: Image.asset(
                            'assets/man_with_laptop.png',
                            scale: 6.0,
                          ).animate(effects: [
                            const FadeEffect(
                                duration: Duration(seconds: 1))
                          ]),
                          showCloseIcon: true,
                          body: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                            ],
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: ConstantFonts.poppinsMedium),
                            controller: _percentController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              // fillColor: const Color(0xffFBF8FF),
                              hintStyle: TextStyle(
                                  fontFamily: ConstantFonts.poppinsMedium,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Colors.black54
                                // (0xffFBF8FF)
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              hintText: '       Percent of Completed',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Enter value';
                              } else {
                                return null;
                              }
                            },
                          ),
                          btnOkColor: Colors.black87,
                          btnOkText: 'Done',
                          buttonsTextStyle: TextStyle(
                            // color: ConstantColor.blackColor,
                              fontWeight: FontWeight.w900,
                              fontFamily: ConstantFonts.poppinsMedium),
                          btnOkOnPress: () {
                            setState(() {
                              // debugPrint(_percentController.text.toString());
                              // percentField.clear();
                            });
                          },
                          onDismissCallback: (type) {
                            // debugPrint('Dialog Dismiss from callback $type');
                          },
                        ).show();
                      });
                    },
                    child: buildNeumorphic(width,height,10,
                      Container(
                        height: height * 0.15,
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _percentController.text.isEmpty
                                  ? Colors.transparent
                                  : Colors.blue,width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(Icons.percent,color: Colors.black,),
                            Text(
                              _percentController.text.isEmpty
                                  ? '--'
                                  : _percentController.text,
                              style: TextStyle(
                                  fontFamily: ConstantFonts.poppinsMedium,
                                  color: Colors.black
                              ),
                            ),
                            Text(
                              'percent',
                              style: TextStyle(
                                  fontFamily: ConstantFonts.poppinsMedium,
                                  color: Colors.black
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Submit Button
            SizedBox(
              height: height*0.13,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (timeOfStart!.isNotEmpty &&
                      timeOfEnd!.isNotEmpty &&
                      _percentController.text.isNotEmpty &&
                      _workController.text.isNotEmpty) {
                    String? startString = timeOfStart
                        .toString()
                        .replaceAll(RegExp(':'), '');
                    String? endString =
                    timeOfEnd.toString().replaceAll(RegExp(':'), '');

                    int startInt = int.parse(startString);
                    int endInt = int.parse(endString);
                    int percent = int.parse(_percentController.text);

                    if (startInt < endInt) {
                      // print('correct time');
                      if (percent <= 100) {
                        // print('correct percent');
                        String st = timeOfStart
                            .toString()
                            .replaceAll(RegExp(r'\D'), ':');
                        String et = timeOfEnd
                            .toString()
                            .replaceAll(RegExp(r'\D'), ':');

                        String startTime = st.toString(); // or if '24:00'
                        String endTime = et.toString(); // or if '12:00

                        var format = DateFormat("HH:mm");
                        var start = format.parse(startTime);
                        var end = format.parse(endTime);

                        if (end.isAfter(start)) {
                          timeDifference = end.difference(start);
                        }
                        var s = timeDifference.toString().length;

                        if (timeDifference.toString().length == 14) {
                          setState(() {
                            totalWorkingTime = timeDifference
                                .toString()
                                .substring(0, s - 10);
                            above6 = int.parse(totalWorkingTime
                                .toString()
                                .substring(0, 1));
                          });
                        } else {
                          setState(() {
                            totalWorkingTime = timeDifference
                                .toString()
                                .substring(0, s - 10);
                            above6 = int.parse(totalWorkingTime
                                .toString()
                                .substring(0, 2));
                          });
                        }

                        if (above6 >= 5) {
                          // print(above6);
                          timeOfEnd = '';
                          timeOfEndView = '';
                          showSnackBar(
                              message:
                              "Work time exceeds 5 hours enter correctly",
                              color: Colors.red.shade500);
                        } else {
                          // print(above6);
                          setState(() {
                            isLoading = true;
                            createNewWork();
                            // print('created');
                          });
                        }
                      } else {
                        _percentController.clear();
                        showSnackBar(
                            message: 'enter correct percentage',
                            color: Colors.red.shade500);
                      }
                    } else {
                      timeOfStart = '';
                      timeOfEnd = '';
                      timeOfStartView = '';
                      timeOfEndView = '';
                      showSnackBar(
                          message: 'Set the work time correctly',
                          color: Colors.red.shade500);
                    }
                  } else {
                    showSnackBar(
                        message: 'Please Fill All Fields',
                        color: Colors.red.shade500);
                  }
                });
              },
              child: buildNeumorphic( width, height,20,
                Container(
                  height: height * 0.08,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsBold,
                          fontSize: height * 0.025,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabBarViewSecondScreen(double height, double width) {
    return workDoneList.isNotEmpty
        ? GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 1.8,
        ),
        itemCount: workDoneList.length,
        itemBuilder: (BuildContext ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildNeumorphic(
              width,height,20, Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  /// Work Details Container...
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.02),
                    padding: const EdgeInsets.all(8),
                    height: height * 0.10,
                    width: width * 0.88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: textWidget(
                        height,
                        workDoneList[index],
                        height * 0.02,
                      ),
                    ),
                  ),

                  /// Time....
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textWidget(height, 'Start : ${startTimeList[index]}',
                          height * 0.020),
                      textWidget(height, 'End : ${endTimeList[index]}',
                          height * 0.020),
                      textWidget(
                          height,
                          'Duration : ${workingHoursList[index]}',
                          height * 0.020),
                    ],
                  ),

                  /// Percentage......
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: percentIndicator(
                        height,
                        percent = double.parse(workPercentageList[index]
                            .replaceAll(RegExp(r'.$'), "")) /
                            100,
                        "${workPercentageList[index]}"),
                  ),
                ],
              ),
            ),
            ),
          );
        })
        : Center(
      child: Text(
        'No Works Completed',
        style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget percentIndicator(double height, double val, String percentage) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.023,
      percent: val,
      backgroundColor: Colors.black.withOpacity(0.05),
      // progressColor: Colors.cyan,
      linearGradient:
      const LinearGradient(colors: [Color(0xff21d4fd), Color(0xffb721ff)]),
      center: Text(
        percentage,
        style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SelectableText(
        name,
        style: TextStyle(
            fontSize: size,
            fontFamily: ConstantFonts.poppinsMedium,
            color: ConstantColor.blackColor),
      ),
    );
  }

  Widget textFiledWidget(
      double height,
      TextInputType textInputType,
      TextInputAction textInputAction,
      String hintName,
      TextEditingController textEditingController) {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: textEditingController,
      textInputAction: textInputAction,
      maxLines: 5,
      autofocus: false,
      keyboardType: textInputType,
      onTap: () {
        setState(() {});
      },
      style: TextStyle(
          fontSize: height * 0.02,
          color: Colors.black,
          fontFamily: ConstantFonts.poppinsRegular),
      decoration: InputDecoration(
        fillColor: Color(0xffDDE6E8),
        border: InputBorder.none,
        hintText: hintName,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        // fillColor: Colors.transparent,
        contentPadding:
        const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget buildNeumorphic(double width, double height,double radius, Widget widget,) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 10),
      style: NeumorphicStyle(
        depth: 3,
        shadowLightColorEmboss: Colors.white12.withOpacity(0.8),
        shadowLightColor: Colors.white.withOpacity(0.8),
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(radius),
        ),
      ),
      child: widget,
    );
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
          height: 50.0,
          color: color,
          child: Center(
            child: Text(
              message,
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String title;

  final VoidCallback onClicked;
  final Icon icon;
  final String val;
  final bool colorValue;

  const ButtonWidget({
    Key? key,
    required this.title,
    required this.onClicked,
    required this.icon,
    required this.val,
    required this.colorValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        margin: EdgeInsets.only(top: height * 0.0),
        height: height * 0.15,
        width: width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: colorValue ? Colors.blue : Colors.transparent,width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            icon,
            Text(
              val,
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  color: Colors.black
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}