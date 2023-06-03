import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_leave_model.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class LeaveApprovalScreen extends StatefulWidget {
  final String uid;
  final String name;
  const LeaveApprovalScreen({super.key, required this.uid, required this.name});

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
            staffLeaves.sort((a, b) => b.date.compareTo(a.date));
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
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return   AlertDialog(
                                        title: Text('Confirmation status',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: ConstantFonts.poppinsRegular,
                                              color: Colors.deepPurple
                                          ),),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text('This is to confirm your approval status for leave request of the employee.',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: ConstantFonts.poppinsRegular,
                                                    color: ConstantColor.headingTextColor
                                                ),),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Approve',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: ConstantFonts.poppinsMedium,
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstantColor.pinkColor
                                              ),),
                                            onPressed: () async {
                                              await changeRequest(
                                                  staffLeaves[index], 'Approved');
                                              setState(() {
                                                approve = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Decline',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: ConstantFonts.poppinsMedium,
                                              color: Colors.red
                                            ),
                                            ),
                                            onPressed: () async {
                                              await changeRequest(
                                              staffLeaves[index], 'Declined');
                                              setState(() {
                                                decline = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Cancel',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: ConstantFonts.poppinsMedium,
                                                  color: ConstantColor.headingTextColor
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                  }
                                  );
                                },
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.6,
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
                                      'Tap to Approve/Cancel',
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
          return Center(
            child: Lottie.asset( "assets/animations/new_loading.json",),
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
      'updated_by' : widget.name,
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
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.green,
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
                  fontWeight: FontWeight.bold,
                  fontFamily: ConstantFonts.poppinsRegular,
                  color: ConstantColor.blackColor),
            ),
            elevation: 10,
            content: ListTile(
              title: Text(
                reason,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantColor.backgroundColor
                  ),
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
