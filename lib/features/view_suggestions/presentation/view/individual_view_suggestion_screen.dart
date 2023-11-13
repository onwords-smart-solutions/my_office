import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_main_template.dart';

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
      bgColor: AppColor.backGroundColor,
    );
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
          color: AppColor.primaryColor,
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
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['date'].toString(),
                  style: const TextStyle(
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
                child: Text(
                  "Is Read",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['isread'].toString(),
                  style: const TextStyle(
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
                child: Text(
                  "Time",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['time'].toString(),
                  style: const TextStyle(
                  ),
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
          color: AppColor.primaryColor,
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
                    color: AppColor.primaryColor,
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
                  style: const TextStyle(
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
