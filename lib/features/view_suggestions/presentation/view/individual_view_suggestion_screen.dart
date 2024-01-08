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
      subtitle: 'Suggestion',
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
          color: Theme.of(context).primaryColor.withOpacity(.2),
          width: 2,
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['date'].toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['isread'].toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.fullSuggestions['time'].toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
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
          color: Theme.of(context).primaryColor.withOpacity(.2),
          width: 2,
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
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
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
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
