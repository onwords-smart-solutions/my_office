import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/main_template.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import 'package:intl/intl.dart';

class AbsenteeScreen extends StatefulWidget {
  const AbsenteeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AbsenteeScreen> createState() => _AbsenteeScreenState();
}

class _AbsenteeScreenState extends State<AbsenteeScreen> {
  bool isLoading = true;
  bool isFuture = false;

  var firebaseData;

  List notEntry = [];
  List allData = [];
  List nameData = [];
  List depData = [];

  String? formattedTime;
  var formattedDate;
  var formattedMonth;
  var formattedYear;

  // final staff = FirebaseDatabase.instance.ref().child("staff");
  final fingerPrint = FirebaseDatabase.instance.ref().child("fingerPrint");
  final virtualAttendance =
      FirebaseDatabase.instance.ref().child('virtualAttendance');

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  String? selectedDate;

  datePicker() async {
    selectedDate = formatterDate.format(now);
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    if (!mounted) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      if (newDate.isAfter(DateTime.now())) {
        notEntry.clear();
        isFuture = true;
      } else {
        if (selectedDate != null) {
          getAbsentsName();
        }
      }
    });
  }

  todayDate() {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterYear = DateFormat('yyyy');
    var formatterMonth = DateFormat('MM');
    formattedTime = DateFormat('kk:mm:a').format(now);
    formattedDate = formatterDate.format(now);
    formattedYear = formatterYear.format(now);
    formattedMonth = formatterMonth.format(now);
  }

  getAbsentsName() {
    isLoading = true;
    isFuture = false;
    notEntry.clear();
    fingerPrint.once().then(
      (value) async {
        for (var val in value.snapshot.children) {
          firebaseData = val.value;

          final staffName = firebaseData['name'];

          try {
            notEntry.add(staffName);
          } catch (e) {
            log(e.toString());
          }

          if (firebaseData[selectedDate] != null) {
            notEntry.remove(staffName);
          } else {
            //CHECKING IN PR ATTENDANCE LOCATION IN FIREBASE
            // WHETHER STAFF HAVE DATA OR NOT
            checkInVirtualStorage(val.key!);
          }
        }

        Future.delayed(
          const Duration(seconds: 1),
          () {
            setState(
              () {
                isLoading = false;
              },
            );
          },
        );
      },
    );
  }

  checkInVirtualStorage(String uid) {
    virtualAttendance
        .child('$uid/$formattedYear/$formattedMonth/$selectedDate/')
        .once()
        .then(
      (value) {
        Map<Object?, Object?> data = {};
        try {
          data = value.snapshot.value as Map<Object?, Object?>;
          setState(() {
            notEntry.remove(data['Name']);
          });
        } catch (e) {
          log('ERROR FROM VIRTUAL ATTENDANCE $e');
        }
      },
    );
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    todayDate();
    getAbsentsName();
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
    List<Widget> absentNames = [];

    for (int i = 0; i < notEntry.length; i++) {
      final widget = Container(
        // height: height * 0.1,
        margin: const EdgeInsets.all(8),
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
              notEntry[i],
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  color: ConstantColor.blackColor,
                  fontSize: 16),
            ),
          ),
        ),
      );
      absentNames.add(widget);
    }

    return Column(
            children: [
              //calender button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: datePicker,
                      child: Image.asset(
                        'assets/calender.png',
                        scale: 3,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text('$selectedDate   ',
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsBold,
                            fontSize: 17,
                            color: ConstantColor.backgroundColor)),
                  ],
                ),
              ),
              Text('Total absentees : ${notEntry.length}',
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsRegular,
                fontWeight: FontWeight.w600,
                fontSize: 17,
                height: 2,
              ),
              ),
              isLoading
                  ? Center(
                child: Lottie.asset(
                  "assets/animations/new_loading.json",
                ),
              )
                  :
              notEntry.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: absentNames,
                        ),
                      ),
                    )
                  : isFuture
                      ? errorMessage('Not available right now')
                      : errorMessage('Everyone present today'),
            ],
          );
  }

  Widget errorMessage(String message) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/no_data.json', height: 250.0),
            Text(
              message,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: Colors.purple,
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
}
