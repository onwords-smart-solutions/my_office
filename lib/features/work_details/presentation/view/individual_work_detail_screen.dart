import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../data/model/work_detail_model.dart';

class IndividualWorkDone extends StatefulWidget {
  final WorkDoneModel workDetails;

  const IndividualWorkDone({
    Key? key,
    required this.workDetails,
  }) : super(key: key);

  @override
  State<IndividualWorkDone> createState() => _IndividualWorkDoneState();
}

class _IndividualWorkDoneState extends State<IndividualWorkDone> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MainTemplate(
      templateBody: workDetailsContainer(height, width),
      subtitle: widget.workDetails.name,
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget workDetailsContainer(double height, double width) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.workDetails.reports.length,
      itemBuilder: (BuildContext context, int ind) {
        return widget.workDetails.reports.isEmpty
            ? Center(
          child: Text(
            'No Work done registered..',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
            : Container(
          height: height * 0.25,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor.withOpacity(.1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: height * 0.015,
                        horizontal: width * 0.01,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: height * 0.1,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                       color: Theme.of(context).primaryColor.withOpacity(.2),
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
                      margin: EdgeInsets.symmetric(horizontal: width * 0.007),
                      child: percentIndicator(
                        height * 2,
                        double.parse(
                          widget.workDetails.reports[ind].percentage
                              .replaceAll(RegExp(r'.$'), ''),
                        ) /
                            100,
                        widget.workDetails.reports[ind].percentage,
                        double.parse(
                          widget.workDetails.reports[ind].percentage
                              .replaceAll(RegExp(r'.$'), ''),
                        ) <
                            50
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        textWidget(
                          height,
                          'Start : ${widget.workDetails.reports[ind].from}',
                          height * 0.009,
                        ),
                        textWidget(
                          height,
                          'End : ${widget.workDetails.reports[ind].to}',
                          height * 0.009,
                        ),
                        textWidget(
                          height,
                          'Duration : ${widget.workDetails.reports[ind].duration}',
                          height * 0.009,
                        ),
                      ],
                    ),
                    const Gap(5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget percentIndicator(
      double height,
      double percent,
      String val,
      Color color,
      ) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: height * 0.013,
      percent: percent,
      barRadius: const Radius.circular(10),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.4),
      progressColor: Theme.of(context).scaffoldBackgroundColor,
      center: Text(
        val,
        style: TextStyle(
          color: color,
          fontSize: height * 0.010,
        ),
      ),
    );
  }

  Widget textWidget(double height, String name, double size) {
    return AutoSizeText(
      name,
      style: TextStyle(
        fontSize: size * 2,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}