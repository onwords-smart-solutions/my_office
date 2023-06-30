import 'package:flutter/material.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class AllSuggestions extends StatefulWidget {
  final Map<Object?, Object?> fullSuggestions;

  const AllSuggestions({Key? key, required this.fullSuggestions})
      : super(key: key);

  @override
  State<AllSuggestions> createState() => _AllSuggestionsState();
}

class _AllSuggestionsState extends State<AllSuggestions> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Date Specific Suggestion!!',
        templateBody: viewAllSuggestions(),
        bgColor: ConstantColor.background1Color);
  }

  Widget viewAllSuggestions() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          buildSuggestionTable(),
          const SizedBox(height: 30),
          buildMessage(),
        ],
      ),
    );
  }

  Widget buildSuggestionTable() {
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
                  "Date",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 17,
                    fontFamily: ConstantFonts.sfProMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['date'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 17,
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
                  "Is Read",
                  style: TextStyle(
                    color: ConstantColor.backgroundColor,
                    fontSize: 17,
                    fontFamily: ConstantFonts.sfProMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['isread'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 17,
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
                    fontSize: 17,
                    fontFamily: ConstantFonts.sfProMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['time'].toString(),
                  style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 17,
                      fontFamily: ConstantFonts.sfProMedium),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMessage() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.5),
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
                    "Message:",
                    style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 17,
                      fontFamily: ConstantFonts.sfProMedium,
                    ),
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
                  child: SelectableText(
                    widget.fullSuggestions['message'].toString(),
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 18,
                      fontFamily: ConstantFonts.sfProMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
