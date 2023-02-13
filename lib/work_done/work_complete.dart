import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class WorkCompleteViewScreen extends StatefulWidget {
  const WorkCompleteViewScreen({Key? key}) : super(key: key);

  @override
  State<WorkCompleteViewScreen> createState() => _WorkCompleteViewScreenState();
}

class _WorkCompleteViewScreenState extends State<WorkCompleteViewScreen> {
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
                    child:  CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: GestureDetector(onTap: (){print('hiii');},child: Image.asset('assets/calender.png')),

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
                          text: 'Complete work details',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: height * 0.020,
                          ),
                        ),
                      ]),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Positioned(
            top: height*0.13,
              left: width*0.0,
              right: width*0.0,
              bottom: height*0.053,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1 / 0.1,
                    mainAxisExtent: 31 / 0.1),
                  itemCount: 5,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: width*0.05),
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
                        children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  textWidget(height, 'name    ', height*0.018),
                                ],
                              ),

                          Container(
                            height: height*0.38,
                            color: Colors.transparent,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [

                                  workDetailsContainer(height, width),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                  },
              ),
          )

        ],
      ),
    );
  }

  Widget workDetailsContainer(double height, double width) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 1 / 0.1,
            mainAxisExtent: 23 / 0.1),
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.02),
                    padding: const EdgeInsets.all(8),
                    height: height * 0.15,
                    width: width * 0.88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: ConstantColor.backgroundColor.withOpacity(0.09),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xffD136D4).withOpacity(0.09),
                          const Color(0xff7652B2).withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: textWidget(
                        height,
                        'Instead of a LinearProgressIndicator, you could used a Container with a gradient and fixed height. The width would correspond to the value of the linear progress indicator times the width of the screen',
                        height * 0.010,
                      ),
                    ),
                  ),
                  percentIndicator(height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textWidget(height, 'Start : 9:30', height * 0.010),
                      textWidget(height, 'End : 9:30', height * 0.010),
                      textWidget(height, 'Hours : 1:00', height * 0.010),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget percentIndicator(double height) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.013,
      // percent: percent = double.parse(workPercentageView[index]
      //     .replaceAll(RegExp(r'.$'), "")) /
      //     100,
      percent: 50 / 100,
      backgroundColor: Colors.black.withOpacity(0.05),
      // progressColor: Colors.cyan,
      linearGradient:
      const LinearGradient(colors: [Color(0xffD136D4), Color(0xff7652B2)]),
      center: Text(
        '50 %',
        style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: Colors.white,
            fontSize: height*0.010,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size,
          fontFamily: ConstantFonts.poppinsMedium,
          color: ConstantColor.blackColor),
    );
  }
}
