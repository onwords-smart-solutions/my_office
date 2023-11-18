import 'dart:convert';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/leave_approval/data/data_source/leave_approval_fb_data_source.dart';
import 'package:my_office/features/leave_approval/data/data_source/leave_approval_fb_data_source_impl.dart';
import 'package:my_office/features/leave_approval/data/model/leave_approval_model.dart';
import 'package:my_office/features/leave_approval/data/repository/leave_approval_repo_impl.dart';
import 'package:my_office/features/leave_approval/domain/entity/leave_approval_user_entity.dart';
import 'package:my_office/features/leave_approval/domain/repository/leave_approval_repository.dart';
import 'package:my_office/features/leave_approval/domain/use_case/change_leave_request_use_case.dart';
import 'package:my_office/features/leave_approval/domain/use_case/check_leave_status_use_case.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../../notifications/presentation/notification_view_model.dart';

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({super.key});

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  final ref = FirebaseDatabase.instance.ref();
  bool decline = false;
  bool approve = false;
  late final CheckLeaveStatusCase _checkLeaveStatusCase;
  late final ChangeLeaveRequestCase _changeLeaveRequestCase;

  @override
  void initState() {
    LeaveApprovalFbDataSource leaveApprovalFbDataSource =
        LeaveApprovalFbDataSourceImpl();
    LeaveApprovalRepository leaveApprovalRepository =
        LeaveApprovalRepoImpl(leaveApprovalFbDataSource);
    _checkLeaveStatusCase =
        CheckLeaveStatusCase(leaveApprovalRepository: leaveApprovalRepository);
    _changeLeaveRequestCase = ChangeLeaveRequestCase(
      leaveApprovalRepository: leaveApprovalRepository,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Leave forms pending for approval!!',
      templateBody: buildLeaveApproval(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildLeaveApproval() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    LeaveApprovalUserEntity user = LeaveApprovalUserEntity(
      uid: '',
      dep: '',
      email: '',
      name: '',
      dob: 0,
      mobile: 0,
      url: '',
      uniqueId: '',
    );

    return StreamBuilder(
      stream: ref.child('leave_details').onValue,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          List<StaffLeaveApprovalModel> staffLeaves = [];
          //Looping inside each year
          for (var year in snapshot.data!.snapshot.children) {
            //Looping inside each month
            for (var month in year.children) {
              //Looping inside the date
              for (var date in month.children) {
                //Looping inside all users
                for (var uid in date.children) {
                  for (var leaveRequest in uid.children) {
                    String name = 'GHOST';
                    String status = 'Pending';
                    String department = 'Not provided';
                    final leaveData =
                        leaveRequest.value as Map<Object?, Object?>;
                    try {
                      name = leaveData['name'].toString();
                      status = leaveData['status'].toString();
                      department = leaveData['dep'].toString() == 'null'
                          ? 'Not provided'
                          : leaveData['dep'].toString();
                    } catch (e) {
                      log('Error while fetching leave details $e');
                    }

                    final data = StaffLeaveApprovalModel(
                      name: name,
                      uid: uid.key.toString(),
                      date: leaveData['date'].toString(),
                      status: status,
                      month: month.key.toString(),
                      year: year.key.toString(),
                      reason: leaveData['reason'].toString(),
                      type: leaveRequest.key.toString(),
                      department: department,
                    );

                    staffLeaves.add(data);
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
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryColor,
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
                              final count = await _checkLeaveStatusCase.execute(
                                staffLeaves[index].date,
                              );
                              if (count >= 3) {
                                if (!mounted) return;
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
                                              color: Colors.purple,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Confirmation status',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.deepPurple,
                                                    ),
                                                  ),
                                                  content:
                                                      const SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        Text(
                                                          'This is the confirmation status for Employee leave request.',
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text(
                                                        'Approve',
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.purple,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        final leaveModel =
                                                            StaffLeaveApprovalModel(
                                                          status: 'Approved',
                                                          uid:
                                                              staffLeaves[index]
                                                                  .uid,
                                                          name:
                                                              staffLeaves[index]
                                                                  .name,
                                                          department:
                                                              staffLeaves[index]
                                                                  .department,
                                                          reason:
                                                              staffLeaves[index]
                                                                  .reason,
                                                          type:
                                                              staffLeaves[index]
                                                                  .type,
                                                          month:
                                                              staffLeaves[index]
                                                                  .month,
                                                          year:
                                                              staffLeaves[index]
                                                                  .year,
                                                          date:
                                                              staffLeaves[index]
                                                                  .date,
                                                        );
                                                        await _changeLeaveRequestCase
                                                            .execute(
                                                          leaveModel,
                                                        );
                                                        setState(() {
                                                          approve = true;
                                                        });
                                                        sendNotification(
                                                          staffLeaves[index]
                                                              .uid,
                                                          'Leave Response',
                                                          'Your leave request has been Approved by ${user.name}',
                                                        );
                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Decline',
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        final leaveModel =
                                                            StaffLeaveApprovalModel(
                                                          status: 'Declined',
                                                          uid:
                                                              staffLeaves[index]
                                                                  .uid,
                                                          name:
                                                              staffLeaves[index]
                                                                  .name,
                                                          department:
                                                              staffLeaves[index]
                                                                  .department,
                                                          reason:
                                                              staffLeaves[index]
                                                                  .reason,
                                                          type:
                                                              staffLeaves[index]
                                                                  .type,
                                                          month:
                                                              staffLeaves[index]
                                                                  .month,
                                                          year:
                                                              staffLeaves[index]
                                                                  .year,
                                                          date:
                                                              staffLeaves[index]
                                                                  .date,
                                                        );
                                                        await _changeLeaveRequestCase
                                                            .execute(
                                                          leaveModel,
                                                        );
                                                        setState(() {
                                                          decline = true;
                                                        });
                                                        sendNotification(
                                                          staffLeaves[index]
                                                              .uid,
                                                          'Leave Response',
                                                          'Your leave request has been Declined by ${user.name}',
                                                        );
                                                        if (!mounted) return;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                              } else {
                                if (!mounted) return;
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text(
                                            'Approve',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          onPressed: () async {
                                            final leaveModel =
                                                StaffLeaveApprovalModel(
                                              status: 'Approved',
                                              uid: staffLeaves[index].uid,
                                              name: staffLeaves[index].name,
                                              department:
                                                  staffLeaves[index].department,
                                              reason: staffLeaves[index].reason,
                                              type: staffLeaves[index].type,
                                              month: staffLeaves[index].month,
                                              year: staffLeaves[index].year,
                                              date: staffLeaves[index].date,
                                            );
                                            await _changeLeaveRequestCase
                                                .execute(
                                              leaveModel,
                                            );
                                            setState(() {
                                              approve = true;
                                            });
                                            sendNotification(
                                              staffLeaves[index].uid,
                                              'Leave Response',
                                              'Your leave request has been Approved by ${user.name}',
                                            );
                                            if (!mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Decline',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          ),
                                          onPressed: () async {
                                            final leaveModel =
                                                StaffLeaveApprovalModel(
                                              status: 'Declined',
                                              uid: staffLeaves[index].uid,
                                              name: staffLeaves[index].name,
                                              department:
                                                  staffLeaves[index].department,
                                              reason: staffLeaves[index].reason,
                                              type: staffLeaves[index].type,
                                              month: staffLeaves[index].month,
                                              year: staffLeaves[index].year,
                                              date: staffLeaves[index].date,
                                            );
                                            await _changeLeaveRequestCase
                                                .execute(
                                              leaveModel,
                                            );
                                            setState(() {
                                              decline = true;
                                            });
                                            sendNotification(
                                              staffLeaves[index].uid,
                                              'Leave Response',
                                              'Your leave request has been Declined by ${user.name}',
                                            );
                                            if (!mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
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
                                    color: AppColor.backGroundColor,
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
            'assets/animations/new_loading.json',
          ),
        );
      },
    );
  }

  //Function to check 3 approved leaves

  //Function to approve leave request

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
              color: AppColor.backGroundColor,
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
      style: const TextStyle(fontSize: 17, color: Colors.black),
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
            title: const Text(
              'Reason :',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            elevation: 10,
            content: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ListTile(
                title: Text(
                  reason,
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColor.primaryColor,
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
        style: const TextStyle(fontSize: 17, color: Colors.black),
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
