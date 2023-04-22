import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/models/staff_leave_model.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class LeaveApprovalScreen extends StatefulWidget {
  final String name;
  final String uid;

  const LeaveApprovalScreen({super.key, required this.name, required this.uid});

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  final ref = FirebaseDatabase.instance.ref();
  bool decline = false;
  bool approve = false;

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Leave forms pending for approval!!',
      templateBody: buildLeaveApproval(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildLeaveApproval() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: ref.child('leaveDetails').onValue,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<StaffLeaveModel> staffLeaves = [];
            //Looping in all users
            for (var uid in snapshot.data!.snapshot.children) {
              //Looping inside each year
              for (var year in uid.child('leaveApplied').children) {
                //Looping inside each month
                for (var month in year.children) {
                  //Looping inside each leave applied
                  for (var leaveRequest in month.children) {
                    String name = 'GHOST';
                    String status = 'Pending';
                    final leaveData =
                        leaveRequest.value as Map<Object?, Object?>;
                    try {
                      name = leaveData['name'].toString();
                      status = leaveData['status'].toString();
                    } catch (e) {
                      log('Error while fetching leave details $e');
                    }

                    final data = StaffLeaveModel(
                        name: name,
                        uid: uid.key.toString(),
                        date: leaveRequest.key.toString(),
                        status: status,
                        month: month.key.toString(),
                        year: year.key.toString(),
                        reason: leaveData['reason'].toString(),
                        type: leaveData['type'].toString());

                    staffLeaves.add(data);
                  }
                }
              }
            }

            final index = staffLeaves.indexWhere(
                (element) => element.status.toLowerCase().contains('pending'));
            if (index < 0) {
              return Center(
                child: Text(
                  'No leave forms available!!',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsRegular,
                    fontWeight: FontWeight.w600,
                    color: ConstantColor.backgroundColor,
                    fontSize: 20,
                  ),
                ),
              );
            }
            //DISPLAYING ALL LEAVE REQUEST
            return ListView.builder(
                itemCount: staffLeaves.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (listCtx, index) {
                  if (staffLeaves[index]
                      .status
                      .toLowerCase()
                      .contains('pending')) {
                    return Container(
                      // height: height * 0.1,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ConstantColor.background1Color,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: ConstantColor.backgroundColor.withOpacity(0.09),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff7652B2).withOpacity(0.09),
                                  const Color(0xffD136D4).withOpacity(0.0),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                textWidget(staffLeaves[index].name, 15.0),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * .4,
                                      child: textWidget('Date', 15),
                                    ),
                                    Expanded(
                                      child: textWidget(
                                          ':  ${staffLeaves[index].date}', 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * .4,
                                      child: textWidget('Reason', 15),
                                    ),
                                    Expanded(
                                      child: reasonContainer(
                                          staffLeaves[index].reason),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * .4,
                                      child: textWidget('Leave Type', 15),
                                    ),
                                    Expanded(
                                      child: textWidget(
                                          ':  ${staffLeaves[index].type}', 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await changeRequest(
                                      staffLeaves[index], 'Approved');
                                  setState(() {
                                    approve = true;
                                  });
                                },
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffD136D4),
                                        Color(0xff7652B2),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Approve',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.poppinsMedium,
                                        color: ConstantColor.background1Color,
                                        fontSize: height * 0.020,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await changeRequest(
                                      staffLeaves[index], 'Declined');
                                  setState(() {
                                    decline = true;
                                  });
                                },
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffD136D4),
                                        Color(0xff7652B2),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Decline',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.poppinsMedium,
                                        color: ConstantColor.background1Color,
                                        fontSize: height * 0.020,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                });
          }
          //Loading section
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  //Function to approve leave request
  Future<void> changeRequest(
      StaffLeaveModel leaveRequest, String status) async {
    await ref
        .child(
            'leaveDetails/${leaveRequest.uid}/leaveApplied/${leaveRequest.year}/${leaveRequest.month}/${leaveRequest.date}')
        .update({
      'status': status,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Leave request for ${leaveRequest.name} has been $status',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: ConstantFonts.poppinsRegular,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: ConstantColor.backgroundColor,
      ),
    );
  }

  Widget buttonWidget(
    double width,
    double height,
    String name,
    Function? val,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          val;
        });
      },
      child: Container(
        height: height * 0.12,
        width: width * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.background1Color,
              fontSize: height * 0.040,
            ),
          ),
        ),
      ),
    );
  }

  Widget textWidget(String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: 16,
          fontFamily: ConstantFonts.poppinsRegular,
          fontWeight: FontWeight.w600,
          color: ConstantColor.blackColor),
    );
  }

  Widget reasonContainer(String reason) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Reason :',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: ConstantFonts.poppinsMedium,
                  color: ConstantColor.blackColor),
            ),
            elevation: 10,
            content: ListTile(
              title: Text(
                reason,
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.backgroundColor),
              ),
            ),
            actions: [
              Container(
                height: height * 0.05,
                width: width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffD136D4),
                      Color(0xff7652B2),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: ConstantFonts.poppinsMedium,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Text(
        ':  $reason',
        style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsRegular,
            fontWeight: FontWeight.w600,
            color: ConstantColor.blackColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
