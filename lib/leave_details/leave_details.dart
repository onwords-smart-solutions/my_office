import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/staff_entry_model.dart';
import '../util/main_template.dart';
import 'all_leave_details.dart';

class LeaveDetails extends StatefulWidget {
  const LeaveDetails({super.key});

  @override
  State<LeaveDetails> createState() => _LeaveDetailsState();
}

class _LeaveDetailsState extends State<LeaveDetails> {
  List<StaffAttendanceModel> allNames = [];
  List<StaffAttendanceModel> allStaffs = [];
  bool isLoading = true;

  String department = 'ALL';
  final List<String> dropDown = [
    'ALL',
    'APP',
    'RND',
    'MEDIA',
    'WEB',
    'PR',
  ];

  //Getting staff names from database
  void allStaffNames() {
    allStaffs.clear();
    allNames.clear();
    var ref = FirebaseDatabase.instance.ref();
    ref.child('staff').once().then((values) {
      for (var uid in values.snapshot.children) {
        var names = uid.value as Map<Object?, Object?>;
        final staffNames = StaffAttendanceModel(
          uid: uid.key.toString(),
          department: names['department'].toString(),
          name: names['name'].toString(),
        );
        if (staffNames.name != 'Nikhil Deepak') {
          allNames.add(staffNames);
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
    allStaffNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Check employee leave details here..',
      templateBody: buildEmployeeNames(),
      bgColor: ConstantColor.background1Color,
    );
  }

  buildEmployeeNames() {
    if (department == 'APP') {
      allStaffs =
          allNames.where((element) => element.department == 'APP').toList();
    } else if (department == 'RND') {
      allStaffs =
          allNames.where((element) => element.department == 'RND').toList();
    } else if (department == 'MEDIA') {
      allStaffs =
          allNames.where((element) => element.department == 'MEDIA').toList();
    } else if (department == 'WEB') {
      allStaffs =
          allNames.where((element) => element.department == 'WEB').toList();
    } else if (department == 'PR') {
      allStaffs =
          allNames.where((element) => element.department == 'PR').toList();
    } else {
      allStaffs = allNames;
    }
    var size = MediaQuery.of(context).size;
    return  isLoading
        ? Center(child: Lottie.asset('assets/animations/leave_loading.json'),)
        :
      Column(
      children: [
        SizedBox(height: size.height * 0.01),
        Text(
          'Total staffs: ${allStaffs.length}',
          style: TextStyle(fontSize: 18, fontFamily: ConstantFonts.sfProBold),
        ),
        Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    position: PopupMenuPosition.under,
                    elevation: 10,
                    itemBuilder: (ctx) => List.generate(
                      dropDown.length,
                      (i) {
                        return PopupMenuItem(
                          child: Text(
                            dropDown[i],
                            style: TextStyle(
                                fontFamily: ConstantFonts.sfProMedium,
                                fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              department = dropDown[i];
                            });
                          },
                        );
                      },
                    ),
                    icon: Icon(
                      Icons.sort,
                      color: department == "APP"
                          ? const Color(0xff6527BE)
                          : department == 'RND'
                              ? const Color(0xff0EA293)
                              : department == 'MEDIA'
                                  ? const Color(0xffDB005B)
                                  : department == 'WEB'
                                      ? const Color(0xff9A208C)
                                      : department == 'PR'
                                          ? const Color(0xffF24C3D)
                                          : Colors.black,
                    ),
                  ),
                  Text(
                    department,
                    style: TextStyle(
                        fontFamily: ConstantFonts.sfProRegular,
                        fontWeight: FontWeight.w600,
                        color: department == "APP"
                            ? const Color(0xff6527BE)
                            : department == 'RND'
                                ? const Color(0xff0EA293)
                                : department == 'MEDIA'
                                    ? const Color(0xffDB005B)
                                    : department == 'WEB'
                                        ? const Color(0xff9A208C)
                                        : department == 'PR'
                                            ? const Color(0xffF24C3D)
                                            : Colors.black,
                        fontSize: 17),
                  ),
                ],
              ),
        Expanded(
          child: ListView.builder(
            itemCount: allStaffs.length,
            itemBuilder: (ctx, i) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    color: Colors.purple,
                  ),
                  title: Text(
                    allStaffs[i].name,
                    style: TextStyle(fontFamily: ConstantFonts.sfProMedium),
                  ),
                  trailing: Text(
                    allStaffs[i].department,
                    style: TextStyle(
                      fontFamily: ConstantFonts.sfProBold,
                      fontSize: 14,
                      color: allStaffs[i].department == 'APP'
                          ? const Color(0xff6527BE)
                          : allStaffs[i].department == 'RND'
                              ? const Color(0xff0EA293)
                              : allStaffs[i].department == 'MEDIA'
                                  ? const Color(0xffDB005B)
                                  : allStaffs[i].department == 'WEB'
                                      ? const Color(0xff9A208C)
                                      : const Color(0xffF24C3D),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AllLeaveDetails(
                          staffUid: allStaffs[i].uid,
                          staffName: allStaffs[i].name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
