import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class RefreshmentsScreen extends StatefulWidget {
  const RefreshmentsScreen({Key? key}) : super(key: key);

  @override
  State<RefreshmentsScreen> createState() => _RefreshmentsScreenState();
}

class _RefreshmentsScreenState extends State<RefreshmentsScreen> {
  List tea = [
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data',
    'data'
  ];

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
            bottom: height * 0.06,
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
                          text: 'Choose your Refreshment here !',
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: height * 0.020,
                          ),
                        ),
                      ]),
                    ),
                  ),

                  ///ShowDialogBox
                  Positioned(
                    top: height * 0.13,
                    // left: width * 0.05,
                    right: width * 0.05,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: dialogTitleWidget(height),
                              content: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: dialogContentWidget(height, width),
                              ),
                              actions: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Container(
                                      height: height * 0.05,
                                      width: width * 0.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffD136D4),
                                            Color(0xff7652B2),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontFamily:
                                                ConstantFonts.poppinsMedium,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/count.png',
                            scale: 4.0,
                          ),
                          Text(
                            'Count',
                            style: TextStyle(
                                fontFamily: ConstantFonts.poppinsRegular,
                                fontSize: height * 0.018),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///Grid View...
                  Positioned(
                    top: height * 0.15,
                    left: width * 0.05,
                    right: width * 0.05,
                    bottom: height * 0.30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        sliderWidget(
                          height,
                          width,
                          'TEA',
                          'Slide to have a Tea',
                          Image.asset(
                            'assets/tea slider.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        sliderWidget(
                          height,
                          width,
                          'COFFEE',
                          'Slide to have a Coffee',
                          Image.asset(
                            'assets/coffee slider.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        sliderWidget(
                          height,
                          width,
                          'FOOD',
                          'Slide to have a Food',
                          Image.asset(
                            'assets/food.png',
                            scale: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Bottom Image...
                ],
              ),
            ),
          ),
      Positioned(
        top: height * 0.65,
        left: width * 0.09,
        right: width * - 0.05,
        bottom: height * 0.0,
        child: Image.asset('assets/man_with_laptop.png',scale: 4.0,),)
        ],
      ),
    );
  }

  Widget dialogTitleWidget(double height) {
    return Container(
      decoration: BoxDecoration(
          color: ConstantColor.background1Color,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            'Refreshment Count',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontSize: height * 0.020,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              countView(
                  height,
                  '  T: 12',
                  Image.asset(
                    'assets/tea.png',
                    scale: 3.5,
                  )),
              countView(
                  height,
                  '  C: 12',
                  Image.asset(
                    'assets/coffee.png',
                    scale: 3.5,
                  )),
              countView(
                  height,
                  '  F: 12',
                  Image.asset(
                    'assets/food.png',
                    scale: 3.8,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget dialogContentWidget(double height, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        nameListWidget(height, width, 'Tea', tea.length, tea),
        nameListWidget(height, width, 'Coffee', tea.length, tea),
        nameListWidget(height, width, 'Food', tea.length, tea),
      ],
    );
  }

  Widget nameListWidget(
      double height, double width, String name, int itemLength, List listName) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      height: height * 0.3,
      decoration: BoxDecoration(
        color: ConstantColor.background1Color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          AutoSizeText(
            name,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontSize: height * 0.020,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.07),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemLength,
                  itemBuilder: (BuildContext context, int ind) {
                    return Text(
                      '${listName[ind]}',
                      style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                        color: ConstantColor.blackColor,
                        fontSize: height * 0.020,
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget countView(
    double height,
    String title,
    Image image,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        image,
        AutoSizeText(
          title,
          style: TextStyle(
            fontFamily: ConstantFonts.poppinsMedium,
            color: ConstantColor.blackColor,
            fontSize: height * 0.015,
          ),
        )
      ],
    );
  }

  Widget sliderWidget(
    double height,
    double width,
    String name,
    String title,
    Image image,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: height * 0.02,
              fontFamily: ConstantFonts.poppinsMedium,
            ),
          ),
        ),
        ConfirmationSlider(
          // stickToEnd: true,
          onConfirmation: () {},
          height: height * 0.07,
          width: width * 0.9,
          backgroundColor: ConstantColor.background1Color,
          foregroundColor: ConstantColor.background1Color,
          backgroundShape: BorderRadius.circular(40),
          text: title,
          sliderButtonContent: image,
        ),
      ],
    );
  }
}
