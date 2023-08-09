import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/screen_template.dart';
import '../Constant/fonts/constant_font.dart';
import 'leave_model.dart';

class AllLeaveDetails extends StatefulWidget {
  final String staffUid;
  final String staffName;

  const AllLeaveDetails(
      {super.key, required this.staffUid, required this.staffName});

  @override
  State<AllLeaveDetails> createState() => _AllLeaveDetailsState();
}

class _AllLeaveDetailsState extends State<AllLeaveDetails> {
  List<LeaveModel> leaves = [];
  List<LeaveModel> staffNames = [];
  bool isLoading = true;
  String currentMonth = DateFormat.MMMM().format(DateTime.now()).toString();
  static const Color green = Colors.green;
  static const Color orange = CupertinoColors.activeOrange;
  static const Color red = Colors.red;

  final Map<String, String> month = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  //Fetching leave status of employees
  void getLeaveStatus() async {
    leaves.clear();
    staffNames.clear();
    final currentMonthFormat = '${DateTime.now().year}-${month[currentMonth]}';
    var ref = FirebaseDatabase.instance.ref();
    await ref.child('leaveDetails').once().then((leave) {
      for (var uid in leave.snapshot.children) {
        for (var leaveApplied in uid.children) {
          for (var year in leaveApplied.children) {
            for (var month in year.children) {
              for (var date in month.children) {
                final dividedFormat = date.key!.substring(0, 7);
                if (dividedFormat.contains(currentMonthFormat)) {
                  final data = date.value as Map<Object?, Object?>;
                  var staffLeaves = date.value as Map<Object?, Object?>;
                  var leaveData = LeaveModel(
                    uid: uid.key.toString(),
                    date: staffLeaves['date'].toString(),
                    dep: staffLeaves['dep'].toString(),
                    name: staffLeaves['name'].toString(),
                    reason: staffLeaves['reason'].toString(),
                    status: staffLeaves['status'].toString(),
                    type: staffLeaves['type'].toString(),
                    updatedBy: staffLeaves['updated_by'].toString(),
                    isApproved: staffLeaves['isapproved'].toString(),
                  );
                  try {
                    if (widget.staffUid == uid.key.toString() &&
                        staffLeaves['date'] != null) {
                      leaves.add(leaveData);
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                }
              }
            }
          }
        }
      }
    });
    if (!mounted) return;
    setState(() {
      staffNames = leaves;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getLeaveStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildDetails(),
      title: widget.staffName,
    );
  }

  buildDetails() {
    var size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                position: PopupMenuPosition.under,
                elevation: 10.0,
                itemBuilder: (ctx) => List.generate(
                  month.length,
                  (index) {
                    return PopupMenuItem(
                      child: Text(
                        month.keys.toList()[index],
                        style: TextStyle(
                            fontFamily: ConstantFonts.sfProMedium,
                            fontSize: 15),
                      ),
                      onTap: () {
                        setState(() {
                          currentMonth = month.keys.toList()[index];
                          isLoading = true;
                          getLeaveStatus();
                        });
                      },
                    );
                  },
                ),
                icon: Image.asset(
                  'assets/calender.png',
                  scale: 3.0,
                ),
              ),
              Text(
                currentMonth,
                style: TextStyle(
                    fontFamily: ConstantFonts.sfProBold, fontSize: 16.0),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: size.height * 0.03,
              width: size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: green,
                ),
                child: Center(
                  child: Text('Approved',
                  style: TextStyle(
                    fontFamily: ConstantFonts.sfProMedium
                  ),
                  ),
                ),
            ),
            Container(
              height: size.height * 0.03,
              width: size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: orange,
                ),
               child: Center(
                 child: Text('Pending',
                   style: TextStyle(
                       fontFamily: ConstantFonts.sfProMedium
                   ),
                 ),
               ),
            ),
            Container(
              height: size.height * 0.03,
              width: size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: red,
                ),
                child: Center(
                  child: Text('Declined',
                    style: TextStyle(
                        fontFamily: ConstantFonts.sfProMedium
                    ),
                  ),
                ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          'Total : ${staffNames.length}',
          style: TextStyle(
              fontFamily: ConstantFonts.sfProBold,
              fontSize: 18,
              color: CupertinoColors.systemPurple),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : staffNames.isEmpty
                  ? Column(
                      children: [
                        Lottie.asset(
                            'assets/animations/no_data.json'),
                        Text(
                          'No leaves has been submitted🤗',
                          style: TextStyle(
                            fontFamily: ConstantFonts.sfProMedium,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: staffNames.length,
                      itemBuilder: (ctx, i) {
                        return staffNames[i].status == 'Approved'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.06),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date - ${staffNames[i].date}',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.sfProMedium,
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Leave type - ${staffNames[i].type}',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.sfProMedium,
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Updated by - ${staffNames[i].updatedBy}',
                                      style: TextStyle(
                                        fontFamily: ConstantFonts.sfProMedium,
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                  ],
                                ),
                              )
                            : staffNames[i].status == 'Pending' ||
                                    staffNames[i].isApproved == 'processing'
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.06),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date - ${staffNames[i].date}',
                                          style: TextStyle(
                                            fontFamily:
                                                ConstantFonts.sfProMedium,
                                            color: CupertinoColors.activeOrange,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Leave type - ${staffNames[i].type}',
                                          style: TextStyle(
                                            fontFamily:
                                                ConstantFonts.sfProMedium,
                                            fontSize: 16,
                                            color: CupertinoColors.activeOrange,
                                          ),
                                        ),
                                        Text(
                                          'Updated by - ${staffNames[i].updatedBy}',
                                          style: TextStyle(
                                            fontFamily: ConstantFonts.sfProMedium,
                                            fontSize: 16,
                                            color: CupertinoColors.activeOrange,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                      ],
                                    ),
                                  )
                                : staffNames[i].status == 'Declined'
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.06),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date - ${staffNames[i].date}',
                                              style: TextStyle(
                                                fontFamily:
                                                    ConstantFonts.sfProMedium,
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Leave type - ${staffNames[i].type}',
                                              style: TextStyle(
                                                fontFamily:
                                                    ConstantFonts.sfProMedium,
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              'Updated by - ${staffNames[i].updatedBy}',
                                              style: TextStyle(
                                                fontFamily: ConstantFonts.sfProMedium,
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                          ],
                                        ),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                      },
                    ),
        ),
      ],
    );
  }
}
