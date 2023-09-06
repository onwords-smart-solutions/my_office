import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_office/util/screen_template.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/work_done_model.dart';

class IndividualWorkDone extends StatefulWidget {
  final WorkDoneModel workDetails;

  const IndividualWorkDone(
      {Key? key, required this.workDetails})
      : super(key: key);

  @override
  State<IndividualWorkDone> createState() => _IndividualWorkDoneState();
}

class _IndividualWorkDoneState extends State<IndividualWorkDone> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ScreenTemplate(
        bodyTemplate: workDetailsContainer(height, width),
        title: widget.workDetails.name);
  }

  Widget workDetailsContainer(double height, double width) {
    // print(widget.workDetails.length.bitLength);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.workDetails.reports.length,
        itemBuilder: (BuildContext context, int ind) {
          return Container(
            height: height * 0.25,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: ConstantColor.background1Color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 8,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.01),
                    padding: const EdgeInsets.all(8),
                    height: height * 0.1,
                    width: width * 0.9,
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
                        widget.workDetails.reports[ind].workdone,
                        height * 0.010,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: percentIndicator(
                      height * 2,
                      double.parse( widget.workDetails.reports[ind].percentage
                              .replaceAll(RegExp(r'.$'), "")) /
                          100,
                      widget.workDetails.reports[ind].percentage,
                      double.parse(widget.workDetails.reports[ind].percentage
                                  .replaceAll(RegExp(r'.$'), "")) <
                              50
                          ? Colors.black
                          : ConstantColor.background1Color,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textWidget(
                          height,
                          'Start : ${widget.workDetails.reports[ind].from}',
                          height * 0.010),
                      textWidget(
                          height,
                          'End : ${widget.workDetails.reports[ind].to}',
                          height * 0.010),
                      textWidget(
                          height,
                          'Duration : ${widget.workDetails.reports[ind].duration}',
                          height * 0.010),
                    ],
                  ),
                ],
              ),
            ),
          );
        },);
  }

  Widget percentIndicator(
      double height, double percent, String val, Color color) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.013,
      percent: percent,
      backgroundColor: Colors.black.withOpacity(0.05),
      // progressColor: Colors.cyan,
      linearGradient:
          const LinearGradient(colors: [Color(0xffD136D4), Color(0xff7652B2)]),
      center: Text(
        val,
        style: TextStyle(
            fontFamily: ConstantFonts.sfProMedium,
            color: color,
            fontSize: height * 0.010,),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
          fontSize: size * 2,
          fontFamily: ConstantFonts.sfProMedium,
          color: ConstantColor.blackColor),
    );
  }
}
