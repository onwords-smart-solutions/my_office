import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class ViewAllAttendance extends StatefulWidget {
  final Map<Object?, Object?> fullViewAttendance;

  const ViewAllAttendance({Key? key, required this.fullViewAttendance})
      : super(key: key);

  @override
  State<ViewAllAttendance> createState() => _ViewAllAttendanceState();
}

class _ViewAllAttendanceState extends State<ViewAllAttendance> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Attendance Details!!',
        templateBody: viewFullAttendancePage(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewFullAttendancePage() {
    return Column(
      children: [
        buildAttendanceTable(),
      ],
    );
  }

  Widget buildAttendanceTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
        },
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
          color: ConstantColor.backgroundColor,
          width: 1.5,
        ),
        children: [
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Name",
                    style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.fullViewAttendance['Name'].toString(),
                    style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProMedium),
                  ),
                ),
              ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Address",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProBold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullViewAttendance['Address'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProMedium),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Latitude",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProBold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullViewAttendance['Latitude'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProMedium),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Longitude",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProBold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullViewAttendance['Longitude'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProMedium),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Time",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProBold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullViewAttendance['Time'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProMedium),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Reason",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProBold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullViewAttendance['Reason'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProMedium),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
