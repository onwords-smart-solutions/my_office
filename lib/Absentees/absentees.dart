// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

  var firebaseData;

  List notEntry = [];
  List allData = [];
  List nameData = [];
  List depData = [];

  datePicker() async {
    selectedDate = formatterDate.format(now);
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      if (selectedDate != null) {
        // loadData();
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



  // loadData() {
  //   staff.once().then((value) {
  //     for (var element in value.snapshot.children) {
  //       // print(element.value);
  //       firebaseData = element.value;
  //       setState(() {
  //         notEntry.add(firebaseData['name']);
  //         notEntry = notEntry.toSet().toList();
  //         if (firebaseData['department'] == "ADMIN") {
  //           setState(() {
  //             notEntry.remove(firebaseData['name']);
  //           });
  //         }
  //       });
  //       for (var element1 in element.children) {
  //         if (element1.key == "workManager") {
  //           for (var element2 in element1.children) {
  //             for (var element3 in element2.children) {
  //               if (element3.key == formattedYear) {
  //                 for (var element4 in element3.children) {
  //                   if (element4.key == formattedMonth) {
  //                     for (var element5 in element4.children) {
  //                       if (element5.key == selectedDate) {
  //                         if (firebaseData['name'] != notEntry) {
  //                           setState(() {
  //                             notEntry.remove(firebaseData['name']);
  //                           });
  //                         }
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   });
  // }

  absentData() {
    fingerPrint.once().then((value) {
      for (var element in value.snapshot.children) {
        // firebaseData = element.value;

        // print(element.value);
          for(var element1 in element.children){
            // print(element1.key);
            if(element1.key == 'name'){
              firebaseData = element.value;
              notEntry.add(firebaseData['name']);
              // print(notEntry);
            }
           if(element1.key == selectedDate){
             for(var element2 in element1.children){
               for(var element3 in element2.children){
                 // print(element3.key);
                 if(element3.key == 'Time'){
                   setState(() {
                     notEntry.remove(firebaseData['name']);
                     // print(notEntry);
                  });
                }
               }
             }
           }

        }
      }
    });
  }

  String userName = '';
  SharedPreferences? preferences;

  late SharedPreferences logData;

  Future getUserDetails() async {
    preferences = await SharedPreferences.getInstance();
    String? name = preferences?.getString('name');
    if (name == null) return;
    setState(() {
      userName = name;
    });
  }


  @override
  void initState() {
    getUserDetails();
    selectedDate = formatterDate.format(now);
    todayDate();
    absentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height * 0.95,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: ConstantColor.background1Color,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: Stack(
          children: [

            ///Top Text...
            Positioned(
              top: height * 0.05,
              left: width * 0.05,
              right: width*0.30,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: userName.isEmpty ? 'Hii \n' :'Hii $userName\n',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.030,
                    ),
                  ),
                  TextSpan(
                    text: 'Absentees',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.020,
                    ),
                  ),
                ]),
              ),
            ),

            /// Grid View
            Positioned(
              top: height * 0.15,
              left: 0,
              right: 0,
              bottom: height * 0.01,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      // mainAxisSpacing: 1 / 0.1,
                      mainAxisExtent: 10 / 0.1,
                  ),
                  itemCount: notEntry.length,
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
                      child: Center(
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: ConstantColor.backgroundColor,
                            child: Icon(Icons.person),
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '${notEntry[index]}\n',
                                    style: TextStyle(
                                        fontFamily:
                                            ConstantFonts.poppinsMedium,
                                        color: ConstantColor.blackColor,
                                        fontSize: height * 0.025),
                                ),
                                TextSpan(
                                  text: 'Department',
                                    style: TextStyle(
                                        fontFamily:
                                        ConstantFonts.poppinsMedium,
                                        color: ConstantColor.blackColor,
                                        fontSize: height * 0.020),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),

            /// Date Picker
            Positioned(
                top: height * 0.083,
                left: width * 0.58,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$selectedDate   ',
                        style:  TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 15,
                            color: ConstantColor.blackColor)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          datePicker();
                          notEntry.clear();
                          // newData();
                        });
                      },
                      child: Image.asset('assets/calender.png',scale: 3.3,)
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
