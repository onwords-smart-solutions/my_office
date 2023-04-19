import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({super.key});

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  bool decline = false;
  bool approve = false;

  setDec() {
    decline = true;
    print('declined');
  }

  setApp() {
    approve = true;
    print('approved');
  }

  List a = [
    'name1',
    'name2',
    // 'name3',
    // 'name4',
  ];

  List images = [
    Image.asset('assets/approve.png'),
    Image.asset('assets/decline.png'),
    Image.asset('assets/pending.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Apply for your leave here!!',
      templateBody: buildLeaveApproval(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildLeaveApproval(){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.95,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: ConstantColor.background1Color,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Stack(
        children: [
          /// Top circle
          Positioned(
            top: height * 0.05,
            // left: width * 0.05,
            right: width * 0.05,
            child: const CircleAvatar(
              backgroundColor: ConstantColor.backgroundColor,
              radius: 20,
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
              ),
            ),
          ),

          ///Top Text...
          Positioned(
            top: height * 0.05,
            left: width * 0.05,
            // right: width*0.0,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Hi Admin\n',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.030,
                  ),
                ),
                TextSpan(
                  text: 'Leave request details',
                  style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    color: ConstantColor.blackColor,
                    fontSize: height * 0.020,
                  ),
                ),
              ]),
            ),
          ),
          Positioned(
            top: height * 0.15,
            left: 0,
            right: 0,
            bottom: height * 0.01,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1 / 0.1,
                    mainAxisExtent: 25 / 0.1),
                itemCount: a.length,
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
                        )
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
                              textWidget(height, a[index], height * 0.023),
                              Image.asset(
                                a[index] == a[index]  ?  approve == true
                                    ? 'assets/approve.png'
                                    : decline == true
                                    ? 'assets/decline.png'
                                    : 'assets/pending.png':'assets/pending.png',
                                scale: 3.0,
                              ),
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
                                MainAxisAlignment.spaceAround,
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
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textWidget(height, ':  10 : 10 : 2023',
                                      height * 0.02),
                                  textWidget(
                                      height, ':  Fever', height * 0.02),
                                  textWidget(
                                    height,
                                    ':  Sick Leave',
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
                                  decline = true;
                                  print(a[index]);
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
          ),
        ],
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

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size,
          fontFamily: ConstantFonts.poppinsRegular,
          color: ConstantColor.blackColor),
    );
  }
}
