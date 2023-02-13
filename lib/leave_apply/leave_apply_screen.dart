import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class LeaveApplyScreen extends StatefulWidget {
  const LeaveApplyScreen({Key? key}) : super(key: key);

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  TextEditingController date = TextEditingController();
  TextEditingController reason = TextEditingController();

  submit(){}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 0.0,
            left: width * 0.0,
            right: width * 0.0,
            bottom: height * 0.05,
            child: Container(
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
                          text: 'Hi Ganesh\n',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: height * 0.030,
                          ),
                        ),
                        TextSpan(
                          text: 'Apply your leave form here !',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: height * 0.020,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  ///Body
                  Positioned(
                      top: height * 0.15,
                      left: width * 0.05,
                      right: width * 0.05,
                      // bottom: height * 0.5,
                      child: Container(
                        height: height * 0.35,
                        width: width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12,offset: Offset(-5.0,5.0),blurRadius: 5)
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textFieldWidget(height, width, 'Select Date','Select Date',const Icon(Icons.today_outlined), date,
                                TextInputType.datetime, TextInputAction.next),
                            textFieldWidget(
                                height,
                                width,
                                'Reason',
                                'Leave Reason',
                                const Icon(Icons.text_format),
                                reason,
                                TextInputType.datetime,
                                TextInputAction.done),
                          ],
                        ),
                      ),
                  ),
                  /// Submit Button
                  Positioned(
                      top: height * 0.58,
                      left: width * 0.05,
                      right: width * 0.05,
                      child: buttonWidget(height,submit(),),),

                ],
              ),
            ),
          ),
          /// Bottom Image
          Positioned(
            top: height * 0.67,
            left: width * 0.05,
            right: width * 0.05,
            child: Image.asset('assets/leave_apply.png',scale: 2.0,),),
        ],
      ),
    );
  }

  Widget buttonWidget(double height, Function? function) {
    return GestureDetector(
      onTap: () {
        setState(() {
          function;
        });
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
              fontSize: height * 0.028,
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
      double height,
      double width,
      String name,
      String title,
      Icon icon,
      TextEditingController textEditingController,
      TextInputType inputType,
      TextInputAction action) {
    return Container(
      height: height * 0.15,
      width: width * 0.8,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ConstantColor.blackColor,
              fontFamily: ConstantFonts.poppinsMedium,
            ),
          ),
          SizedBox(
            height: height*0.07,
            child: TextFormField(
              controller: textEditingController,
              textInputAction: action,
              keyboardType: inputType,
              autocorrect: true,
              style: TextStyle(
                color: ConstantColor.blackColor,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
              decoration: InputDecoration(
                hintText: name,
                prefixIcon: icon,
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                    fontFamily: ConstantFonts.poppinsMedium),
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
        ],
      ),
    );
  }
}
