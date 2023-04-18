import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_entry_model.dart';
import 'package:my_office/tl_check_screen/staff_entry_check.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class CheckEntryScreen extends StatefulWidget {
  final String userId;
  final String staffName;

  const CheckEntryScreen(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<CheckEntryScreen> createState() => _CheckEntryScreenState();
}

class _CheckEntryScreenState extends State<CheckEntryScreen> {
  List<StaffAttendanceModel> allAttendance = [];
  List<StaffAttendanceModel> itStaffNames = [];
  List<StaffAttendanceModel> prStaffNames = [];
  List<StaffAttendanceModel> rndStaffNames = [];
  List<StaffAttendanceModel> adminStaffNames = [];
  bool isLoading = true;
  final ref = FirebaseDatabase.instance.ref();

  void staffDetails() {
    allAttendance.clear();
    List<StaffAttendanceModel> fullEntry = [];
    ref.child('staff_details').once().then((staffEntry) {
      for (var data in staffEntry.snapshot.children) {
        var entry = data.value as Map<Object?, Object?>;
        final staffEntry = StaffAttendanceModel(
          uid: data.key.toString(),
          department:entry['department'].toString(),
          name: entry['name'].toString(),
        );
        fullEntry.add(staffEntry);

        if (staffEntry.department == "MEDIA" || staffEntry.department == "WEB" || staffEntry.department == "APP") {
          itStaffNames.add(staffEntry);
        }
        if (staffEntry.department == "RND") {
          rndStaffNames.add(staffEntry);
        }
        if (staffEntry.department == "PR") {
          prStaffNames.add(staffEntry);
        }
        if (staffEntry.department == "MEDIA" ||
            staffEntry.department == "WEB" ||
            staffEntry.department == "APP" ||
            staffEntry.department == "RND" ||
            staffEntry.department == "PR") {
          adminStaffNames.add(staffEntry);
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
    staffDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Attendance entry!!!',
      templateBody: checkEntry(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget checkEntry() {
    return isLoading
        ? Center(
            child: Lottie.asset(
              "assets/animations/loading.json",
            ),
          )
        : widget.staffName == 'Koushik Romel'
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: itStaffNames.length,
                itemBuilder: (ctx, i) {
                  return Container(
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
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StaffEntryCheckScreen(
                              staffDetail: itStaffNames[i],
                            ),
                          ),
                        ),
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: ConstantColor.backgroundColor,
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          itStaffNames[i].name,
                          style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.020),
                        ),
                      ),
                    ),
                  );
                },
              )
            : widget.staffName == 'Prem Kumar'
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: rndStaffNames.length,
                    itemBuilder: (ctx, i) {
                      return Container(
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => StaffEntryCheckScreen(
                                  staffDetail: rndStaffNames[i],
                                ),
                              ),
                            ),
                            leading: const CircleAvatar(
                              radius: 20,
                              backgroundColor: ConstantColor.backgroundColor,
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              rndStaffNames[i].name,
                              style: TextStyle(
                                  fontFamily: ConstantFonts.poppinsMedium,
                                  color: ConstantColor.blackColor,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.020),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : widget.staffName == 'Anitha'
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: prStaffNames.length,
                        itemBuilder: (ctx, i) {
                          return Container(
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
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StaffEntryCheckScreen(
                                      staffDetail: prStaffNames[i],
                                    ),
                                  ),
                                ),
                                leading: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      ConstantColor.backgroundColor,
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  prStaffNames[i].name,
                                  style: TextStyle(
                                      fontFamily: ConstantFonts.poppinsMedium,
                                      color: ConstantColor.blackColor,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.020),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : widget.staffName == 'Devendiran'
                        ? ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: adminStaffNames.length,
                            itemBuilder: (ctx, i) {
                              return Container(
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
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => StaffEntryCheckScreen(
                                          staffDetail: adminStaffNames[i],
                                        ),
                                      ),
                                    ),
                                    leading: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          ConstantColor.backgroundColor,
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text(
                                      adminStaffNames[i].name,
                                      style: TextStyle(
                                          fontFamily:
                                              ConstantFonts.poppinsMedium,
                                          color: ConstantColor.blackColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.020),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No Entry Registered!!!',
                              style: TextStyle(
                                color: ConstantColor.backgroundColor,
                                fontSize: 22,
                                fontFamily: ConstantFonts.poppinsMedium,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
  }
}
