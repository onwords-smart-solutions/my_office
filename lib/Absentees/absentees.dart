import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/main_template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import 'package:intl/intl.dart';

class AbsenteeScreen extends StatefulWidget {
  const AbsenteeScreen({Key? key}) : super(key: key);

  @override
  State<AbsenteeScreen> createState() => _AbsenteeScreenState();
}

class _AbsenteeScreenState extends State<AbsenteeScreen> {
  final staff = FirebaseDatabase.instance.ref().child("staff");
  final fingerPrint = FirebaseDatabase.instance.ref().child("fingerPrint");

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  String? selectedDate;

  datePicker() async {
    selectedDate = formatterDate.format(now);
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    if (!mounted) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      if (selectedDate != null) {
        getAbsentsName();
      }
    });
  }

  String? formattedTime;
  var formattedDate;
  var formattedMonth;
  var formattedYear;

  todayDate() {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyy-MM-dd');
    var formatterYear = DateFormat('yyy');
    var formatterMonth = DateFormat('MM');
    formattedTime = DateFormat('kk:mm:a').format(now);
    formattedDate = formatterDate.format(now);
    formattedYear = formatterYear.format(now);
    formattedMonth = formatterMonth.format(now);
  }

  var firebaseData;

  List notEntry = [];
  List allData = [];
  List nameData = [];
  List depData = [];

  getAbsentsName() {
    notEntry.clear();
    fingerPrint.once().then((value) {
      for (var val in value.snapshot.children) {
        firebaseData = val.value;
        try {
          notEntry.add(firebaseData['name']);
        } catch (e) {
          log(e.toString());
        }

        for (var val1 in val.children) {
          if (val1.key == selectedDate) {
            if (!mounted) return;
            setState(() {
              notEntry.remove(firebaseData['name']);
              notEntry.removeWhere((value) => value == null);
            });
          }
        }
      }
    });
  }

  String userName = '';
  SharedPreferences? preferences;

  late SharedPreferences logData;



  @override
  void initState() {
    // getUserDetails();
    selectedDate = formatterDate.format(now);
    todayDate();
    // loadData();
    getAbsentsName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
        subtitle: 'Absentees',
        templateBody: bodyContent(height, width),
        bgColor: ConstantColor.background1Color);
  }

  Widget bodyContent(
      double height,
      double width,
      ) {
    return Stack(
      children: [
        /// Grid View
        Positioned(
          top: height * 0.01,
          left: 0,
          right: 0,
          bottom: height * 0.01,
          child: notEntry.isEmpty
              ? Center(
            child: Lottie.asset(
              "assets/animations/loading.json",
            ),
          )
              : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                // mainAxisSpacing: 1 / 0.1,
                mainAxisExtent: 7.5 / 0.1,
              ),
              itemCount: notEntry.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: ConstantColor.backgroundColor,
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          notEntry[index],
                          style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontSize: height * 0.020),
                        )),
                  ),
                );
              }),
        ),

        /// Date Picker
        Positioned(
            top: height * -0.0,
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
                        datePicker();
                        notEntry.clear();

                        getAbsentsName();
                      });
                    },
                    child: Image.asset(
                      'assets/calender.png',
                      scale: 3.3,
                    )),
              ],
            )),
      ],
    );
  }
}