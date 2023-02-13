// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class WorkEntryScreen extends StatefulWidget {
  const WorkEntryScreen({Key? key}) : super(key: key);

  @override
  State<WorkEntryScreen> createState() => _WorkEntryScreenState();
}

class _WorkEntryScreenState extends State<WorkEntryScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  final staff = FirebaseDatabase.instance.ref().child("staff");
  final user = FirebaseAuth.instance.currentUser;
  final fingerPrint = FirebaseDatabase.instance.ref().child("fingerPrint");

  final TextEditingController _addressController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  double percent = 0;

  var startTime;
  var endTime;

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
    // print(formattedTime);
    // print(formattedDate);
  }

  String userName = '';
  String mailID = '';
  String department = '';

  SharedPreferences? preferences;

  late SharedPreferences logData;

  Future getSharedPreference() async {
    preferences = await SharedPreferences.getInstance();
    String? name = preferences?.getString('name');
    String? emailId = preferences?.getString('email');
    String? dep = preferences?.getString('department');
    if (name == null) return;
    setState(() {
      userName = name;
      mailID = emailId!;
      department = dep!;
    });
  }





  String? currentUser;
  var fbData;
  var totalTime;
  List nameList = [];
  List endTimeList = [];
  List startTimeList = [];
  List workDoneList = [];
  List workPercentageList = [];
  List totalWorkingTimeList = [];
  List dayTotalWrk = [];

  viewWorkDone() {
    nameList.clear();
    totalWorkingTimeList.clear();
    startTimeList.clear();
    endTimeList.clear();
    workPercentageList.clear();
    workDoneList.clear();
    staff.once().then((value) {
      for (var step1 in value.snapshot.children) {
        fbData = step1.value;
        if (fbData['email'] == currentUser) {
          for (var step2 in step1.children) {
            if (step2.key == "workManager") {
              for (var step3 in step2.children) {
                for (var step4 in step3.children) {
                  if (step4.key == formattedYear) {
                    for (var step5 in step4.children) {
                      if (step5.key == formattedMonth) {
                        for (var step6 in step5.children) {
                          if (step6.key == formattedDate) {
                            for (var step7 in step6.children) {
                              fbData = step7.value;
                              if (fbData['to'] != null) {
                                nameList.remove(fbData['to']);
                                setState(() {
                                  startTimeList.add(fbData['from']);
                                  endTimeList.add(fbData['to']);
                                  workPercentageList.add(fbData['workPercentage']);
                                  workDoneList.add(fbData['workDone']);
                                  totalWorkingTimeList.add(fbData['time_in_hours']);
                                  nameList.add(fbData['name']);
                                  // print(nameView);
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
      }
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getSharedPreference();
    todayDate();
    viewWorkDone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 0.0,
            left: width * 0.0,
            right: width * 0.0,
            bottom: height * 0.05,
            child: Container(
              height: height * 0.95,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ConstantColor.background1Color,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Stack(
                children: [
                  /// Top circle
                  Positioned(
                    top: height * 0.05,
                    // left: width * 0.05,
                    right: width * 0.05,
                    child: const CircleAvatar(
                      backgroundColor: ConstantColor.backgroundColor,
                      radius: 20,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///Top Text...
                  Positioned(
                    top: height * 0.05,
                    left: width * 0.05,
                    // right: width*0.0,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Hi Ganesh\n',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: height * 0.030,
                          ),
                        ),
                        TextSpan(
                          text: 'Update your works here !',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: height * 0.020,
                          ),
                        ),
                      ]),
                    ),
                  ),

                  /// TabBar...
                  Positioned(
                    top: height * 0.15,
                    left: width * 0.05,
                    right: width * 0.05,
                    // bottom: height * 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: height * 0.08,
                      decoration: BoxDecoration(
                        color: ConstantColor.background1Color,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(-6.0, 6.0),
                              blurRadius: 5),
                        ],
                      ),
                      child: tabBarContainer(height, width),
                    ),
                  ),

                  /// TabBarView...
                  Positioned(
                    top: height * 0.25,
                    left: width * 0.01,
                    right: width * 0.01,
                    bottom: height * 0.01,
                    child: tabViewContainer(height, width),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBarContainer(double height, double width) {
    return TabBar(
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
          borderRadius: BorderRadius.circular(10.0)),
      labelColor: Colors.white,
      unselectedLabelColor: ConstantColor.blackColor,
      automaticIndicatorColorAdjustment: true,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w800, fontFamily: ConstantFonts.poppinsMedium),
      tabs: [
        Container(
          height: height * 0.05,
          width: width * 0.3,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Center(child: Text('Work Done')),
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
    return Container(
      height: height * 0.7,
      color: Colors.transparent,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Text Field
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-0.0, 6.0),
                        blurRadius: 5),
                  ]),
              child: textFiledWidget(height, TextInputType.text,
                  TextInputAction.done, 'Enter Work', _addressController),
            ),

            /// 3 Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                timeAndPercentageButtonWidget(height, width,
                    const Icon(Icons.timer_outlined), 'Start', startTime()),
                timeAndPercentageButtonWidget(height, width,
                    const Icon(Icons.timer_outlined), 'End', endTime()),
                timeAndPercentageButtonWidget(height, width,
                    const Icon(Icons.percent), 'Percent', endTime()),
              ],
            ),

            /// Submit Button
            Container(
              margin: EdgeInsets.only(top: height * 0.04),
              height: height * 0.07,
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffD136D4),
                    Color(0xff7652B2),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: height * 0.025,
                      color: Colors.white),
                ),
              ),
            ),

            /// Bottom Image
            Padding(
              padding: EdgeInsets.only(top: height * 0.023,left: width*0.1),
              child: Center(
                  child: Image.asset(
                'assets/man_with_laptop.png',
                scale: 6.5,
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget tabBarViewSecondScreen(double height, double width) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 1 / 0.1,
            mainAxisExtent: 25 / 0.1),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: height * 0.1,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.02),
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
                      workDoneList[index],
                      height * 0.02,
                    ),
                  ),
                ),
                percentIndicator(height,workPercentageList[index]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    textWidget(height, 'Start : 9:30', height * 0.020),
                    textWidget(height, 'End : 9:30', height * 0.020),
                    textWidget(height, 'Hours : 1:00', height * 0.020),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget percentIndicator(double height,int index) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.022,
      percent: percent = double.parse(workPercentageList[index]
          .replaceAll(RegExp(r'.$'), "")) /
          100,
      // percent: 50 / 100,
      backgroundColor: Colors.black.withOpacity(0.05),
      // progressColor: Colors.cyan,
      linearGradient:
          const LinearGradient(colors: [Color(0xffD136D4), Color(0xff7652B2)]),
      center: Text(
        '50 %',
        style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size,
          fontFamily: ConstantFonts.poppinsRegular,
          color: ConstantColor.blackColor),
    );
  }

  Widget timeAndPercentageButtonWidget(double height, double width, Icon icon,
      String name, CallbackAction? function) {
    return GestureDetector(
      onTap: () {
        setState(() {
          function;
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: height * 0.03),
        height: height * 0.09,
        width: width * 0.25,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            icon,
            Text(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFiledWidget(
      double height,
      TextInputType textInputType,
      TextInputAction textInputAction,
      String hintName,
      TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: textEditingController,
        textInputAction: textInputAction,
        maxLines: 5,
        autofocus: false,
        keyboardType: textInputType,
        style: TextStyle(
            fontSize: height * 0.02,
            color: Colors.black,
            fontFamily: ConstantFonts.poppinsRegular),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintName,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ConstantColor.background1Color),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
