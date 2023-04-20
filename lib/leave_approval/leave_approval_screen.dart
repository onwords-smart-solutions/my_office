import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  bool isLoading = true;
  List<dynamic> dbLeaveForms = [];
  bool decline = false;
  bool approve = false;

  // List a = [
  //   'Devendiran',
  //   'Jibin K John',
  //   'Mohan',
  //   'Vinith',
  // ];

  List images = [
    Image.asset('assets/approve.png'),
    Image.asset('assets/decline.png'),
    Image.asset('assets/pending.png'),
  ];

  void getLeaveForms() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> leaveForms = [];
    final formRef = FirebaseDatabase.instance.ref('leaveDetails');
    await formRef.child('${widget.uid}/leaveApplied').once().then((forms) {
      if (forms.snapshot.exists) {
        for (var year in forms.snapshot.children) {
          for (var month in year.children) {
            for (var date in month.children) {
              final status = date.value;
              leaveForms.add(status);
            }
          }
        }
      }
    });
    if (!mounted) return;
    setState(() {
      isLoading = false;
      dbLeaveForms = leaveForms;
    });
  }

  @override
  void initState() {
    getLeaveForms();
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
    return isLoading ? const Center(
        child: CircularProgressIndicator(),
    ) : Container(
      height: height * 0.95,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: ConstantColor.background1Color,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 5,
              mainAxisExtent: 29 / 0.1),
          itemCount: dbLeaveForms.length,
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
                  ),
                ],
                borderRadius: BorderRadius.circular(11),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: height * 0.05,
                    width: width * 0.88,
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
                        textWidget(height, dbLeaveForms[index]['name'],
                            height * 0.023),
                      ],
                    ),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.05),
                        width: width * 0.3,
                        height: height * 0.13,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(height, 'Date', height * 0.02),
                            textWidget(height, 'Reason', height * 0.02),
                            textWidget(
                                height, 'Leave Type', height * 0.02),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.4,
                        height: height * 0.13,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                height,
                                ':  ${dbLeaveForms[index]['date']}',
                                height * 0.02),
                            reasonContainer(index),
                            textWidget(
                              height,
                              ':  ${dbLeaveForms[index]['type']}',
                              height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (approve = true) {
                              'assets/approve.png';
                            } else {
                              'assets/approve.png';
                            }
                          });
                        },
                        child: Container(
                          height: height * 0.05,
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            approve = true;
                          });
                        },
                        child: Container(
                          height: height * 0.05,
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
                    ],
                  )
                ],
              ),
            );
          }),
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

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size,
          fontFamily: ConstantFonts.poppinsRegular,
          color: ConstantColor.blackColor),
    );
  }

  Widget reasonContainer(index) {
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
                '${dbLeaveForms[index]['reason']}',
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
                  child: Text('Ok',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: ConstantFonts.poppinsMedium,
                        color: Colors.white),),
                ),
              ),
            ],
          ),
        );
      },
      child: Text(
        ':  ${dbLeaveForms[index]['reason']}',
        style: TextStyle(
            fontSize: 17,
            fontFamily: ConstantFonts.poppinsRegular,
            color: ConstantColor.blackColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
