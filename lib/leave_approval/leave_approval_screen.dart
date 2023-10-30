import 'dart:convert';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/staff_leave_model.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/services/notification_service.dart';
import 'package:provider/provider.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import 'package:http/http.dart' as http;
import '../util/main_template.dart';

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({super.key});

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  final ref = FirebaseDatabase.instance.ref();
  bool decline = false;
  bool approve = false;

  @override
  void initState() {
    super.initState();
  }

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
    final user = Provider.of<UserProvider>(context, listen: false);

    return StreamBuilder(
      stream: ref.child('leave_details').onValue,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          List<StaffLeaveModel> staffLeaves = [];
          //Looping inside each year
          for (var year in snapshot.data!.snapshot.children) {
            //Looping inside each month
            for (var month in year.children) {
                //Looping inside the date
              for(var date in month.children){
                //Looping inside all users
              for(var uid in date.children) {
                //Looping inside the leave type
                for(var leaveType in uid.children) {
                  log('Leave type is is ${leaveType.value}');

                  for (var leaveRequest in leaveType.children) {
                    String name = 'GHOST';
                    String status = 'Pending';
                    String department = 'Not provided';
                    final leaveData = leaveRequest.value as Map<Object?,
                        Object?>;
                    try {
                      name = leaveData['name'].toString();
                      status = leaveData['status'].toString();
                      department = leaveData['dep'].toString() == 'null'
                          ? 'Not provided'
                          : leaveData['dep'].toString();
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
                      type: leaveData['type'].toString(),
                      department: department,
                    );

                    staffLeaves.add(data);
                  }
                }
              }
                }
              }
            }

          final index = staffLeaves.indexWhere(
                (element) => element.status.toLowerCase().contains('pending'),
          );

          if (index < 0) {
            return Center(
              child: Text(
                'No leave forms available!!',
                style: TextStyle(
                  fontFamily: ConstantFonts.sfProRegular,
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
            itemBuilder: (listCtx, index) {
              if (staffLeaves[index].status.toLowerCase().contains('pending')) {
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
                                    ':  ${staffLeaves[index].date}',
                                    15,
                                  ),
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
                                    staffLeaves[index].reason,
                                  ),
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
                                    ':  ${staffLeaves[index].type}',
                                    15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * .4,
                                  child: textWidget('Department', 15),
                                ),
                                Expanded(
                                  child: textWidget(
                                    ':  ${staffLeaves[index].department}',
                                    15,
                                  ),
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

                              final count = await checkLeaveStatus(staffLeaves[index].date);
                              if(count >= 3){
                                if(!mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Leave Approval limit!!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red,
                                        ),
                                      ),
                                      content: const SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                              'Leave approval limit for the day has already reached 3. Do you want to approve this leave?.',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: ConstantColor
                                                    .headingTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FilledButton.tonal(
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: ConstantColor.pinkColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Confirmation status',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: ConstantFonts.sfProBold,
                                                      color: Colors.deepPurple,
                                                    ),
                                                  ),
                                                  content: const SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        Text(
                                                          'This is the confirmation status for Employee leave request.',
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: ConstantColor
                                                                .headingTextColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Approve',
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontFamily: ConstantFonts.sfProBold,
                                                          color: ConstantColor.pinkColor,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await changeRequest(
                                                          staffLeaves[index],
                                                          'Approved',
                                                        );
                                                        setState(() {
                                                          approve = true;
                                                        });
                                                        sendNotification(
                                                          staffLeaves[index].uid,
                                                          'Leave Response',
                                                          'Your leave request has been Approved by ${user.user!.name}',
                                                        );
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Decline',
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontFamily: ConstantFonts.sfProBold,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await changeRequest(
                                                          staffLeaves[index],
                                                          'Declined',
                                                        );
                                                        setState(() {
                                                          decline = true;
                                                        });
                                                        sendNotification(
                                                          staffLeaves[index].uid,
                                                          'Leave Response',
                                                          'Your leave request has been Declined by ${user.user!.name}',
                                                        );
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontFamily: ConstantFonts.sfProBold,
                                                          color:
                                                          ConstantColor.headingTextColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        FilledButton.tonal(
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.red,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }else{
                                if(!mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Confirmation status',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      content: const SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                              'This is the confirmation status for Employee leave request.',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: ConstantColor
                                                    .headingTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: ConstantFonts.sfProBold,
                                              color: ConstantColor.pinkColor,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await changeRequest(
                                              staffLeaves[index],
                                              'Approved',
                                            );
                                            setState(() {
                                              approve = true;
                                            });
                                            sendNotification(
                                              staffLeaves[index].uid,
                                              'Leave Response',
                                              'Your leave request has been Approved by ${user.user!.name}',
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Decline',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: ConstantFonts.sfProBold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await changeRequest(
                                              staffLeaves[index],
                                              'Declined',
                                            );
                                            setState(() {
                                              decline = true;
                                            });
                                            sendNotification(
                                              staffLeaves[index].uid,
                                              'Leave Response',
                                              'Your leave request has been Declined by ${user.user!.name}',
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: ConstantFonts.sfProBold,
                                              color:
                                              ConstantColor.headingTextColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }

                            },
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                    color: ConstantColor.background1Color,
                                    fontSize: height * 0.021,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
        //Loading section
        return Center(
          child: Lottie.asset(
            "assets/animations/new_loading.json",
          ),
        );
      },
    );
  }

  //Function to check 3 approved leaves
  Future<int> checkLeaveStatus(String date) async {
    final splittedDate=date.split('-');
    int statusCount = 0;
    await ref.child('leaveDetails').once().then((value) async {
      for (var staff in value.snapshot.children) {
        if (staff
            .child('leaveApplied/${splittedDate[0]}/${splittedDate[1]}/$date/status')
            .value
            .toString() ==
            'Approved') {
          statusCount += 1;
        }
      }
    });
    log('Leave Count for $date is $statusCount');
    return statusCount;
  }

  //Function to approve leave request
  Future<void> changeRequest(
      StaffLeaveModel leaveRequest,
      String status,
      ) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await ref
        .child(
      'leaveDetails/${leaveRequest.uid}/leaveApplied/${leaveRequest.year}/${leaveRequest.month}/${leaveRequest.date}',
    )
        .update({
      'updated_by': user.user!.name,
      'status': status,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Leave request for ${leaveRequest.name} has been $status',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
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
              fontFamily: ConstantFonts.sfProRegular,
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
      style: const TextStyle(fontSize: 17, color: ConstantColor.blackColor),
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
                fontFamily: ConstantFonts.sfProBold,
                color: ConstantColor.blackColor,
              ),
            ),
            elevation: 10,
            content: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ListTile(
                title: Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 17,
                    color: ConstantColor.backgroundColor,
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                height: height * 0.05,
                width: width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Text(
        ':  $reason',
        style: const TextStyle(fontSize: 17, color: ConstantColor.blackColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //Leave approve status for employees
  Future<void> sendNotification(
      String userId,
      String title,
      String body,
      ) async {
    final tokens = await NotificationService().getDeviceFcm(userId: userId);
    for (var token in tokens) {
      await NotificationService().sendNotification(
        title: title,
        body: body,
        token: token,
        type: NotificationType.leaveRespond,
      );
    }
  }
}