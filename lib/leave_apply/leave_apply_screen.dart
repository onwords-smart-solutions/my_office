import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';
import 'package:http/http.dart' as http;

class LeaveApplyScreen extends StatefulWidget {
  final String name;
  final String uid;
  final String department;

  const LeaveApplyScreen({Key? key, required this.name, required this.uid, required this.department})
      : super(key: key);

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController leaveReason = TextEditingController();
  TabController? _tabController;
  DateTime? dateTime;
  String? _reason;
  bool isLoading = true;
  List<dynamic> dbLeaveStatus = [];

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      dateTime = newDate;
    });
  }
  List<String> mgmtTokens = [
    '58JIRnAbechEMJl8edlLvRzHcW52',
    'hCxvT3mh1sgORNUMjsSNc9rgxgk2',
    'QPgtT8vDV8Y9pdy8fhtOmBON1Q03',
    'Vhbt8jIAfiaV1HxuWERLqJh7dbj2',
    'ZIuUpLfSIRgRN5EqP7feKA9SbbS2',
    'pztngdZPCPQrEvmI37b3gf3w33d2',
    'Ae6DcpP2XmbtEf88OA8oSHQVpFB2',
    'eGMgZ4YlXjRRAhytqEDtGIBRdtW2',
    '7lunH9jV0sV5EE2YzjjBrQWyVk72',
    '6WHjHuUai5ZimnLz4URUDssaMWj1',
  ];

  Future<void> sendNotification(
      String userId, String title, String body) async {
    FirebaseFirestore.instance
        .collection('Devices')
        .doc(userId)
        .get()
        .then((value) async {
      if (value.exists) {
        final data = value.data();
        final mgmtDeviceToken = data!['Token'];
        if (mgmtDeviceToken != null) {
          const url = 'https://fcm.googleapis.com/fcm/send';
          const serverKey =
              'AAAAhAGZ-Jw:APA91bFk_GTSGX1LAj-ZxOW7DQn8Q69sYLStSB8lukQDlxBMmugrkQCsgIvuFm0fU5vBbVB5SATjaoO0mrCdsJm03ZEEZtaRdH-lQ9ZmX5RpYuyLytWyHVH7oDu-6LaShqrVE5vYHCqK'; // Your FCM server key
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          };

          final payload = {
            'notification': {
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'screen' : 'LeaveApprovalScreen',
              'status': 'done',
            },
            'to': mgmtDeviceToken,
          };

          final response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(payload),
          );

          if (response.statusCode == 200) {
            print('Notification sent successfully!');
          } else {
            print(
                'Error sending notification. Status code: ${response.statusCode}');
          }
        }
      }
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    checkLeaveStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Apply for your leave here!!',
      templateBody: buildContent(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildContent() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
            top: height * 0.0,
            left: width * 0.0,
            right: width * 0.0,
            bottom: height * 0.0,
            child: Stack(
              children: [
                //Tab bar
                Positioned(
                  top: height * 0.02,
                  left: width * 0.05,
                  right: width * 0.05,
                  // bottom: height * 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    height: height * 0.08,
                    decoration: BoxDecoration(
                      color: ConstantColor.background1Color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(-6.0, 6.0),
                            blurRadius: 5),
                      ],
                    ),
                    child: tabBarContainer(height, width),
                  ),
                ),

                //Tab bar view
                Positioned(
                  top: height * 0.13,
                  left: width * 0.01,
                  right: width * 0.01,
                  bottom: height * 0.0,
                  child: tabViewContainer(height, width),
                ),
              ],
            ),
        ),
      ],
    );
  }

  Widget tabBarViewFirstScreen(double height, double width) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.90,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ConstantColor.background1Color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: height * 0.02,
            left: width * 0.05,
            right: width * 0.05,
            // bottom: height * 0.5,
            child: Container(
              height: height * 0.43,
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-5.0, 5.0),
                      blurRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  textFieldWidget('Reason for leave...', 'Reason :',
                      leaveReason, TextInputType.name, TextInputAction.done),
                ],
              ),
            ),
          ),

          /// Submit Button
          Positioned(
            top: height * 0.55,
            left: width * 0.05,
            right: width * 0.05,
            child: buttonWidget(),
          ),
        ],
      ),
    );
  }

  Widget tabBarViewSecondScreen(double height, double width) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? Center(
                  child: Lottie.asset(
                    "assets/animations/loading.json",
                  ),
                )
              : dbLeaveStatus.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animations/no_data.json',
                            height: 250.0),
                        Text(
                          'No leave forms submitted!!',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: dbLeaveStatus.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              Color changeColors = ConstantColor.backgroundColor;

                       switch(dbLeaveStatus[i]['status'].toString().toLowerCase()){
                         case 'pending':changeColors = Colors.grey.shade500;break;
                         case 'declined':changeColors = Colors.red;break;
                         case 'approved':changeColors = Colors.green;break;
                       }

                              return ListTile(
                                title: Text(
                                  '${dbLeaveStatus[i]['date'].toString()}   ',
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    color: ConstantColor.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Text(
                                  dbLeaveStatus[i]['reason'].toString(),
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsRegular,
                                    fontWeight: FontWeight.w600,
                                    color: ConstantColor.backgroundColor,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: Text(
                                  '(${dbLeaveStatus[i]['status'].toString().toUpperCase()})',
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    color: changeColors,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
        )
      ],
    );
  }

  Widget tabBarContainer(double height, double width) {
    return TabBar(
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      indicator: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffD136D4),
            Color(0xff7652B2),
          ],
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: ConstantColor.blackColor,
      automaticIndicatorColorAdjustment: true,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          fontFamily: ConstantFonts.poppinsMedium),
      tabs: [
        Container(
          height: height * 0.05,
          width: width * 0.3,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: const Center(
            child: Text(
              'Leave form',
            ),
          ),
        ),
        Container(
          height: height * 0.05,
          width: width * 0.3,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: const Center(
            child: Text(
              'Leave status',
            ),
          ),
        ),
      ],
    );
  }

  Widget tabViewContainer(double height, double width) {
    return Container(
      height: height * 0.9,
      color: Colors.transparent,
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        children: [
          // First Screen
          tabBarViewFirstScreen(height, width),
          // Second Screen
          tabBarViewSecondScreen(height, width),
        ],
      ),
    );
  }

  Widget buttonWidget() {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
         addLeaveToDb();
      },
      child: Container(
        height: height * 0.07,
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
            'Submit',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.background1Color,
              fontWeight: FontWeight.w700,
              fontSize: height * 0.028,
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
      String name,
      String title,
      TextEditingController textEditingController,
      TextInputType inputType,
      TextInputAction action) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDatePicker(),
          const SizedBox(height: 17),
          Text(
            title,
            style: TextStyle(
              color: ConstantColor.headingTextColor,
              fontFamily: ConstantFonts.poppinsMedium,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: TextFormField(
              controller: textEditingController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: action,
              keyboardType: inputType,
              maxLines: 4,
              style: TextStyle(
                color: ConstantColor.blackColor,
                fontFamily: ConstantFonts.poppinsRegular,
                fontWeight: FontWeight.w600
              ),
              decoration: InputDecoration(
                hintText: name,
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.3),
                    fontFamily: ConstantFonts.poppinsRegular,
                fontWeight: FontWeight.bold,
                fontSize: 17),
                filled: true,
                fillColor: ConstantColor.background1Color,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // buildDepartment(),
          radioButtons(),
        ],
      ),
    );
  }

  Widget radioButtons() {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(
          width: width * 0.38,
          child: RadioListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title: Text("Sick",
                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium)),
            value: "Sick leave",
            groupValue: _reason,
            onChanged: (value) {
              setState(() {
                _reason = value.toString();
              });
            },
          ),
        ),
        SizedBox(
          width: width * 0.4,
          child: RadioListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title: Text("General",
                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium)),
            value: "General leave",
            groupValue: _reason,
            onChanged: (value) {
              setState(() {
                _reason = value.toString();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              datePicker();
            },
            child: Text(
              'Date : ',
              style: TextStyle(
                color: ConstantColor.background1Color,
                fontSize: 18,
                fontFamily: ConstantFonts.poppinsMedium,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          dateTime == null ? '' : DateFormat('dd-MM-yyyy').format(dateTime!),
          style: TextStyle(
            color: ConstantColor.headingTextColor,
            fontSize: 18,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

   void addLeaveToDb() async {
    if (dateTime == null) {
      final snackBar = SnackBar(
        content: Text(
          'Select the date for leave!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (leaveReason.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Reason should be filled!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (_reason == null) {
      final snackBar = SnackBar(
        content: Text(
          'Fill the type for your leave..Sick/General',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final leaveRef = FirebaseDatabase.instance.ref('leaveDetails');
      var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime!);
      var monthFormat = DateFormat('MM').format(dateTime!);
      var yearFormat = DateFormat('yyyy').format(dateTime!);
      leaveRef
          .child(
              '${widget.uid}/leaveApplied/$yearFormat/$monthFormat/$dateFormat')
          .update({
        'date': DateFormat('yyyy-MM-dd').format(dateTime!),
        'status': 'Pending',
        'reason': leaveReason.text.trim(),
        'type': _reason,
        'name': widget.name,
        'dep': widget.department,
      });
      final snackBar = SnackBar(
        content: Text(
          'Leave form has been submitted',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      checkLeaveStatus();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      for(var mgmt in mgmtTokens){
        sendNotification( mgmt, 'My Office',
        'New leave form has been submitted by ${widget.name}..');
      }
      leaveReason.clear();
      setState(() {
        _reason = null;
        dateTime = null;
      });
    }
  }

  void checkLeaveStatus() async {
    setState(() {
      isLoading = true;
    });
    final ref = FirebaseDatabase.instance.ref('leaveDetails');
    List<dynamic> leaveStatus = [];
    await ref.child('${widget.uid}/leaveApplied').once().then((leave) {
      if (leave.snapshot.exists) {
        for (var year in leave.snapshot.children) {
          for (var month in year.children) {
            for (var date in month.children) {
              final status = date.value;
              leaveStatus.add(status);
            }
          }
        }
        leaveStatus.sort(
            (a, b) => b['date'].toString().compareTo(a['date'].toString()));
      }
    });
    if (!mounted) return;
    setState(() {
      isLoading = false;
      dbLeaveStatus = leaveStatus;
    });
  }
}
