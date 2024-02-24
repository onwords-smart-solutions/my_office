
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/work_entry/data/data_source/work_entry_fb_data_source.dart';
import 'package:my_office/features/work_entry/data/data_source/work_entry_fb_data_source_impl.dart';
import 'package:my_office/features/work_entry/data/model/work_entry_model.dart';
import 'package:my_office/features/work_entry/data/repository/work_entry_repo_impl.dart';
import 'package:my_office/features/work_entry/domain/repository/work_entry_repository.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../core/utilities/constants/app_main_template.dart';

class WorkEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const WorkEntryScreen({
    Key? key,
    required this.userId,
    required this.staffName,
  }) : super(key: key);

  @override
  State<WorkEntryScreen> createState() => _WorkEntryScreenState();
}

class _WorkEntryScreenState extends State<WorkEntryScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final SpeechToText _speechToText = SpeechToText();
  bool isListening = false;
  String recognizedWords = '';
  bool isCalled = false;

  final workmanager = FirebaseDatabase.instance.ref().child('workmanager');
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int above6 = 0;
  double percent = 0;
  bool isLoading = false;

  dynamic timeDifference;
  String? timeOfStart = '';
  String? timeOfEnd = '';
  String? percentage = '';
  String? timeOfStartView = '';
  String? timeOfEndView = '';
  String? from;
  String? to;

  dynamic totalWorkingTime;

  dynamic formattedDate;
  dynamic formattedMonth;
  dynamic formattedYear;
  String? formattedTime;

  List<WorkEntryRecord> workRecords = [];

  late WorkEntryFbDataSource workEntryFbDataSource =
      WorkEntryFbDataSourceImpl();
  late WorkEntryRepository workEntryRepository =
      WorkEntryRepoImpl(workEntryFbDataSource: workEntryFbDataSource);

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

 getWorkDone() async{
   final response =  await workEntryRepository.getWorkDone(
      widget.userId,
      formattedYear,
      formattedMonth,
      formattedDate,
    );
   setState(() {
     workRecords = response;
   });
  }


  createNewWork() {
    if (timeOfStart != null && timeOfEnd != null) {
      isLoading = true;

      WorkEntryRecord newRecord = WorkEntryRecord(
        startTime: timeOfStart!.trim(),
        endTime: timeOfEnd!.trim(),
        workDone: _workController.text.trim(),
        workPercentage: '${_percentController.text.trim()}%',
        name: widget.staffName.toString().trim(),
        timeInHours: totalWorkingTime,
      );

      workEntryRepository.createNewWork(
        widget.userId,
        formattedYear,
        formattedMonth,
        formattedDate,
        newRecord,
      );
      timeOfStart = '';
      timeOfEnd = '';
      timeOfStartView = '';
      timeOfEndView = '';
      _workController.clear();
      _percentController.clear();
      getWorkDone();
      CustomSnackBar.showSuccessSnackbar(
        message: 'Work entry has been successfully updated!',
        context: context,
      );
      isLoading = false;
    }
  }

  startTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (!mounted) return;
    if (pickedTime != null) {
      final today = DateTime.now();
      DateTime parsedTime = DateTime(
        today.year,
        today.month,
        today.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      ///converting to DateTime so that we can further format on different pattern.
      String formattedTime = DateFormat('HH:mm').format(parsedTime);

      ///DateFormat() is from intl package, you can format the time on any pattern you need.

      setState(() {
        timeOfStart = formattedTime;
        timeOfStartView = DateFormat.jm()
            .format(DateFormat('hh:mm:ss').parse('$formattedTime:00'));
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
      final today = DateTime.now();
      DateTime parsedTime = DateTime(
        today.year,
        today.month,
        today.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      ///converting to DateTime so that we can further format on different pattern.
      // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      String formattedTime = DateFormat('HH:mm').format(parsedTime);

      ///DateFormat() is from intl package, you can format the time on any pattern you need.
      setState(() {
        timeOfEnd = formattedTime;
        timeOfEndView = DateFormat.jm()
            .format(DateFormat('hh:mm:ss').parse('$formattedTime:00'));
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
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
      key: formKey,
      subtitle: 'Work entry',
      templateBody: bodyContent(height, width),
      bgColor: AppColor.backGroundColor,
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
                child: Container(
                  padding: const EdgeInsets.all(5),
                  height: height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                  ),
                  child: tabBarContainer(height, width),
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
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.resolveWith (
            (Set  states) {
          return states.contains(MaterialState.focused) ? null : Colors.transparent;
        },
      ),
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      indicator: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      unselectedLabelColor: Theme.of(context).primaryColor,
      automaticIndicatorColorAdjustment: true,
      dividerColor: Colors.transparent,
      labelStyle: TextStyle(
        fontSize: 17,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
        fontFamily: "SF Pro",
      ),
      tabs: [
        Container(
          height: height * 0.05,
          width: width * 0.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              'Work Entry',
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Container(
          height: height * 0.05,
          width: width * 0.6,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              'Work History',
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
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
        ? Center(
      child:  Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
      Lottie.asset('assets/animations/loading_light_theme.json'):
      Lottie.asset('assets/animations/loading_dark_theme.json'),
          )
        : Padding(
            padding: const EdgeInsets.all(08),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// Text Field
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _workController.text.isEmpty
                            ? Theme.of(context).primaryColor.withOpacity(.3)
                            : Theme.of(context).primaryColor.withOpacity(.5),
                        width: 2,
                      ),
                    ),
                    child: textFiledWidget(
                      height,
                      TextInputType.text,
                      TextInputAction.done,
                      'Enter your work here..',
                      _workController,
                    ),
                  ),

                  /// 3 Buttons
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonWidget(
                          title: 'Start Time',
                          onClicked: () {
                            startTime();
                          },
                          colorValue: timeOfStart.toString().isEmpty
                              ? a = false
                              : a = true,
                          icon: Icon(Icons.alarm, color: Theme.of(context).primaryColor,),
                          val: "${timeOfStart!.isEmpty ? '--' : timeOfStart}",
                        ),
                        ButtonWidget(
                          title: 'End Time',
                          onClicked: () {
                            endTime();
                          },
                          colorValue: timeOfEnd.toString().isEmpty
                              ? b = false
                              : b = true,
                          icon: Icon(Icons.alarm,color: Theme.of(context).primaryColor,),
                          val: "${timeOfEnd!.isEmpty ? '--' : timeOfEnd}",
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
                                ).animate(
                                  effects: [
                                    const FadeEffect(
                                      duration: Duration(seconds: 1),
                                    ),
                                  ],
                                ),
                                showCloseIcon: true,
                                closeIcon: Icon(Icons.close, color: Theme.of(context).primaryColor,),
                                btnOkColor: Theme.of(context).primaryColor.withOpacity(.2),
                                body: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  style: TextStyle(
                                    height: 1,
                                    color:Theme.of(context).primaryColor,
                                  ),
                                  controller: _percentController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    // fillColor: const Color(0xffFBF8FF),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor.withOpacity(.4),
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                    hintText: '       Completed percentage',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(.2),width:2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(.2)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(.4),width: 2),
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
                                btnOkText: 'Done',
                                buttonsTextStyle: TextStyle(
                                  fontSize: 17,
                                  color: Theme.of(context).primaryColor,
                                ),
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
                          child: Container(
                            margin: EdgeInsets.only(top: height * 0.03),
                            height: height * 0.15,
                            width: width * 0.25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _percentController.text.isEmpty
                                    ? Theme.of(context).primaryColor.withOpacity(.3)
                                    : Theme.of(context).primaryColor.withOpacity(.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.percent, color: Theme.of(context).primaryColor,),
                                Text(
                                  _percentController.text.isEmpty
                                      ? '--'
                                      : _percentController.text,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  'Percentage',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Submit Button
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

                              var format = DateFormat('HH:mm');
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
                                  above6 = int.parse(
                                    totalWorkingTime.toString().substring(0, 1),
                                  );
                                });
                              } else {
                                setState(() {
                                  totalWorkingTime = timeDifference
                                      .toString()
                                      .substring(0, s - 10);
                                  above6 = int.parse(
                                    totalWorkingTime.toString().substring(0, 2),
                                  );
                                });
                              }

                              if (above6 >= 6) {
                                // print(above6);
                                timeOfEnd = '';
                                timeOfEndView = '';
                                CustomSnackBar.showErrorSnackbar(
                                  message: 'Enter correct time, it exceeds 6 hrs!',
                                  context: context,
                                );
                              } else {
                                setState(() {
                                  isLoading = true;
                                  createNewWork();
                                });
                              }
                            } else {
                              _percentController.clear();
                              CustomSnackBar.showErrorSnackbar(
                                message: 'Enter correct percentage!',
                                context: context,
                              );
                            }
                          } else {
                            timeOfStart = '';
                            timeOfEnd = '';
                            timeOfStartView = '';
                            timeOfEndView = '';
                            CustomSnackBar.showErrorSnackbar(
                              message: 'Set the work time correctly!',
                              context: context,
                            );
                          }
                        } else {
                          CustomSnackBar.showErrorSnackbar(
                            message: 'Please fill all the fields!!',
                            context: context,
                          );
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.15),
                      height: height * 0.07,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                       color: Theme.of(context).primaryColor.withOpacity(.2),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: height * 0.025,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
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
    return workRecords.isNotEmpty
        ? GridView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 1.8,
            ),
            itemCount: workRecords.length,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                // padding: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
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
                        color: Theme.of(context).primaryColor.withOpacity(.2),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: textWidget(
                          height,
                          workRecords[index].workDone,
                          height * 0.02,
                        ),
                      ),
                    ),

                    /// Time....
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        textWidget(
                          height,
                          'Start : ${workRecords[index].startTime}',
                          height * 0.019,
                        ),
                        textWidget(
                          height,
                          'End : ${workRecords[index].endTime}',
                          height * 0.019,
                        ),
                        textWidget(
                          height,
                          'Duration : ${workRecords[index].timeInHours}',
                          height * 0.019,
                        ),
                      ],
                    ),

                    /// Percentage......
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: percentIndicator(
                        height,
                        percent = double.parse(
                          workRecords[index].workPercentage
                                  .replaceAll(RegExp(r'.$'), ''),
                            ) /
                            100,
                        workRecords[index].workPercentage,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Center(
            child: Text(
              'No Works Completed!!',
              style: TextStyle(
                  fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
              ),
            ),
          );
  }

  Widget percentIndicator(double height, double val, String percentage) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.023,
      percent: val,
      barRadius: const Radius.circular(10),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.4),
      progressColor: Theme.of(context).scaffoldBackgroundColor,
      center: Text(
        percentage,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
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
            color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget textFiledWidget(
    double height,
    TextInputType textInputType,
    TextInputAction textInputAction,
    String hintName,
    TextEditingController textEditingController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: textEditingController,
        textInputAction: textInputAction,
        textCapitalization: TextCapitalization.sentences,
        maxLines: 5,
        autofocus: false,
        keyboardType: textInputType,
        onFieldSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            setState(() {
              recognizedWords = value.trim();
            });
          }
        },
        onTap: () {
          setState(() {});
        },
        style: TextStyle(
          fontSize: height * 0.02,
          color: Theme.of(context).primaryColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintName,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(.3),
          ),
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10.0),
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
        margin: EdgeInsets.only(top: height * 0.03),
        height: height * 0.15,
        width: width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorValue ? Theme.of(context).primaryColor.withOpacity(.5)
                  : Theme.of(context).primaryColor.withOpacity(.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            icon,
            Text(
              val,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
