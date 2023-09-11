import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/staff_entry_model.dart';
import '../util/main_template.dart';
import 'full_details.dart';

class StaffDetails extends StatefulWidget {
  const StaffDetails({super.key});

  @override
  State<StaffDetails> createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {
  List<StaffAttendanceModel> allNames = [];
  List<StaffAttendanceModel> allStaffs = [];
  bool isLoading = true;
  String imageUrl = '';

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
          profileImage: names['profileImage'].toString(),
          emailId: names['email'].toString(),
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
      subtitle: 'Onwords staff details🧑‍💻👨‍‍💼',
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
    return isLoading
        ? Center(
            child: Lottie.asset('assets/animations/leave_loading.json'),
          )
        : Column(
            children: [
              SizedBox(height: size.height * 0.01),
              Text(
                'Total staffs: ${allStaffs.length}',
                style: TextStyle(
                    fontSize: 18, fontFamily: ConstantFonts.sfProBold),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info,
                              color: Colors.grey,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              'Tap to View staff details',
                              style: TextStyle(
                                  color: Colors.grey,
                                   ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.grey),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              'Long press to Delete staff details',
                              style: TextStyle(
                                  color: Colors.grey,
                                   ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: size.width * 0.04),
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
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: GridView.builder(
                  itemCount: allStaffs.length,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.14 / 1.1,
                    crossAxisCount: 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 1,
                  ),
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FullStaffDetails(
                                  allDetails: allStaffs[i],
                                )));
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text(
                                '⚠️Warning!!!',
                                style: TextStyle(
                                    fontSize: 18,
                                   
                                    color: CupertinoColors.destructiveRed),
                              ),
                              content: RichText(
                                text: TextSpan(
                                  text: 'Do you want to delete all details of ',
                                  style: TextStyle(
                                      fontSize: 17,
                                     
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: allStaffs[i].name,
                                      style: TextStyle(
                                          fontSize: 17,
                                         
                                          color: Colors.red),
                                    ),
                                    TextSpan(
                                      text: ' from Onwords database?',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily:
                                              ConstantFonts.sfProMedium),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: FilledButton.tonal(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: ConstantFonts.sfProBold,
                                          color:
                                              CupertinoColors.destructiveRed),
                                    ),
                                    onPressed: () async {
                                      await FirebaseDatabase.instance
                                          .ref('staff/${allStaffs[i].uid}')
                                          .remove();
                                      await FirebaseDatabase.instance
                                          .ref(
                                              'staff_details/${allStaffs[i].uid}')
                                          .remove();
                                      await FirebaseDatabase.instance
                                          .ref(
                                              'fingerPrint/${allStaffs[i].uid}')
                                          .remove();
                                      await FirebaseDatabase.instance
                                          .ref(
                                              'virtualAttendance/${allStaffs[i].uid}')
                                          .remove();
                                      allStaffNames();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: FilledButton.tonal(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontFamily: ConstantFonts.sfProBold,
                                          fontSize: 17),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            allStaffs[i].name,
                            style: TextStyle(
                             
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
                          SizedBox(
                            height: size.height * 0.13,
                            width: size.width * 0.24,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: allStaffs[i].profileImage!.isEmpty
                                  ? const Image(
                                      image:
                                          AssetImage('assets/profile_pic.png'))
                                  : CachedNetworkImage(
                                      imageUrl: allStaffs[i].profileImage!,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              color:
                                                  ConstantColor.backgroundColor,
                                              strokeWidth: 2,
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Image(
                                        image: AssetImage(
                                            'assets/profile_pic.png'),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
  }
}
