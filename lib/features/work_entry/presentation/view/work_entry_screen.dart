
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

  void _initSpeech() async {
    isListening = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _workController.text = result.recognizedWords;
    });
  }

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
    _initSpeech();
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
      subtitle: 'Update your works here!!',
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
                    color: AppColor.backGroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-6.0, 6.0),
                        blurRadius: 5,
                      ),
                    ],
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
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      indicator: BoxDecoration(
        // color: Color(0xffDDE6E8),
        gradient: const LinearGradient(
          colors: [
            Color(0xffD136D4),
            Color(0xff7652B2),
          ],
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      unselectedLabelColor: Colors.black,
      automaticIndicatorColorAdjustment: true,
      labelStyle: const TextStyle(
        fontSize: 17,
      ),
      tabs: [
        Container(
          height: height * 0.05,
          width: width * 0.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Center(
            child: Text(
              'Work Entry',
              style: TextStyle(
                fontSize: 17,
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
          child: const Center(
            child: Text(
              'Work History',
              style: TextStyle(
                fontSize: 17,
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
            child: Lottie.asset(
              'assets/animations/new_loading.json',
            ),
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
                            ? Colors.black26
                            : Colors.green,
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
                          icon: const Icon(Icons.alarm),
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
                          icon: const Icon(Icons.alarm),
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
                                body: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  style: const TextStyle(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  controller: _percentController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    // fillColor: const Color(0xffFBF8FF),
                                    hintStyle: const TextStyle(
                                      fontSize: 16, color: Colors.black54,
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
                                btnOkText: 'Done',
                                buttonsTextStyle: const TextStyle(
                                  fontSize: 17,
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
                                    ? Colors.black26
                                    : Colors.green,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(Icons.percent),
                                Text(
                                  _percentController.text.isEmpty
                                      ? '--'
                                      : _percentController.text,
                                  style: const TextStyle(),
                                ),
                                const Text(
                                  'Percentage',
                                  style: TextStyle(),
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
                            message: 'Please fill all the fields!',
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
                            fontSize: height * 0.025,
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
                  color: AppColor.backGroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(-0.0, 5.0),
                      blurRadius: 8,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(11),
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
        : const Center(
            child: Text(
              'No Works Completed!!',
              style: TextStyle(fontSize: 17),
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
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SelectableText(
        name,
        style: TextStyle(fontSize: size, color: Colors.black),
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
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintName,
          prefixIcon: IconButton(
            icon: Icon(
              _speechToText.isNotListening ? Icons.mic_off_rounded : Icons.mic,
            ),
            onPressed: () {
              setState(() {
                _speechToText.isNotListening
                    ? _startListening()
                    : _stopListening();
              });
            },
          ),
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
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
            color: colorValue ? Colors.green : Colors.black26,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            icon,
            Text(
              val,
            ),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
