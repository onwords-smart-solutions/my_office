import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:timelines/timelines.dart';

import '../view/individual_customer_lead_screen.dart';

class CustomerItem extends StatefulWidget {
  final Map<Object?, Object?> customerInfo;
  final String currentStaffName;
  final List<String> prNames;
  final bool isLeadChange;

  const CustomerItem({
    Key? key,
    required this.customerInfo,
    required this.currentStaffName,
    required this.prNames,
    required this.isLeadChange,
  }) : super(key: key);

  @override
  State<CustomerItem> createState() => _CustomerItemState();
}

class _CustomerItemState extends State<CustomerItem>
    with AutomaticKeepAliveClientMixin {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String lastNote = 'Notes not updated';
    String lastNoteDate = '';

    String fullReminder = 'Reminder not set';

    if (widget.customerInfo['notes'] != null) {
      //Getting all notes from customer data
      final Map<Object?, Object?> allNotes =
          widget.customerInfo['notes'] as Map<Object?, Object?>;
      final noteKeys = allNotes.keys.toList();

      //Checking if key is empty or not
      if (noteKeys.isNotEmpty) {
        noteKeys.sort((a, b) => b.toString().compareTo(a.toString()));
        final Map<Object?, Object?> firstNote =
            allNotes[noteKeys[0]] as Map<Object?, Object?>;
        lastNote = firstNote['note'].toString();
        lastNoteDate = firstNote['date'].toString();
      }
    }

    if (widget.customerInfo['notes'] != null) {
      //Getting all reminders from customer data
      final Map<Object?, Object?> allReminders =
          widget.customerInfo['notes'] as Map<Object?, Object?>;
      final reminder = allReminders.keys.toList();

      //Checking if reminder is empty or not
      if (reminder.isNotEmpty) {
        reminder.sort((a, b) => b.toString().compareTo(a.toString()));
        final Map<Object?, Object?> firstReminder =
            allReminders[reminder[0]] as Map<Object?, Object?>;
        fullReminder = firstReminder['reminder'].toString();
      }
    }

    Color tileColor = Theme.of(context).primaryColor.withOpacity(.1);
    Color nobColor = AppColor.primaryColor;
    final size = MediaQuery.of(context).size;
    List<String> fields = [
      'Name',
      'Customer id',
      'Phone no',
      'Location',
      'Enquiry For',
      'Created date',
      'Lead in charge',
      'Status',
      'Gate',
      'Secondary number',
      'Note',
      'Note updated',
      'Reminder date',
    ];
    List<String> values = [
      widget.customerInfo['name'].toString(),
      widget.customerInfo['customer_id'].toString(),
      widget.customerInfo['phone_number'].toString(),
      widget.customerInfo['city'].toString(),
      widget.customerInfo['inquired_for'].toString(),
      widget.customerInfo['created_date'].toString(),
      widget.customerInfo['LeadIncharge'].toString(),
      widget.customerInfo['customer_state'].toString(),
      widget.customerInfo['gate_type'].toString(),
      widget.customerInfo['work_phone_number'].toString(),
      lastNote,
      lastNoteDate,
      fullReminder,
    ];

    //Changing color based on customer state
    if (widget.customerInfo['customer_state']
            .toString()
            .toLowerCase()
            .contains('rejected') ||
        widget.customerInfo['customer_state']
            .toString()
            .toLowerCase()
            .contains('onwords')) {
      tileColor = const Color(0xffBF3131);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('following up')) {
      tileColor = const Color(0xff4F6F52);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('delayed')) {
      tileColor = const Color(0xffE36414);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('advanced')) {
      tileColor = const Color(0xff4B527E);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('b2b')) {
      tileColor = const Color(0xff994D1C);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('under construction')) {
      tileColor = const Color(0xff706233);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('installation completed')) {
      tileColor = const Color(0xff9D44C0);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('product')) {
      tileColor = const Color(0xffC23373);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('others')) {
      tileColor = const Color(0xff61677A);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
            .toString()
            .toLowerCase()
            .contains('interested') ||
        (widget.customerInfo['customer_state']
            .toString()
            .toLowerCase()
            .contains('hot lead'))) {
      tileColor = const Color(0xff7C73C0);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('visited')) {
      tileColor = const Color(0xff1D5D9B);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('need to visit')) {
      tileColor = const Color(0xffC38154);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('quotation')) {
      tileColor = const Color(0xffA4907C);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    } else if (widget.customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('new leads')) {
      tileColor = const Color(0xffCD5C08);
      nobColor = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.black26 : Colors.white70;
    }
    return GestureDetector(
      onTap: widget.isLeadChange
          ? null
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CustomerDetailScreen(
                    customerInfo: widget.customerInfo,
                    containerColor: tileColor,
                    nobColor: nobColor,
                    currentStaffName: widget.currentStaffName,
                    customerStatus:
                        widget.customerInfo['customer_state'].toString(),
                    leadName: widget.customerInfo['LeadIncharge'].toString(),
                    prStaffNames: widget.prNames,
                    reminder: fullReminder,
                    pageKey : widget.customerInfo['phone_number'].toString(),
                  ),
                ),
              ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: tileColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            buildField(
              field: fields[0],
              value: values[0],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[1],
              value: values[1],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[2],
              value: values[2],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[3],
              value: values[3],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[4],
              value: values[4],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[5],
              value: values[5],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[6],
              value: values[6],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[7],
              value: values[7],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[8],
              value: values[8],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[9],
              value: values[9],
              nobColor: nobColor,
              size: size,
            ),
            buildField(
              field: fields[010],
              value: values[010],
              nobColor: nobColor,
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  Widget buildField({
    required String field,
    required String value,
    required Color nobColor,
    required Size size,
  }) {
    bool isTimeToUpdate = false;
    if (field == "Note updated" && value.isNotEmpty) {
      final lastNoteUpdate = DateTime.parse(value);

      if (calculateDifference(lastNoteUpdate) <= -7) {
        isTimeToUpdate = true;
      }
    }
    return TimelineTile(
      nodePosition: .35,
      oppositeContents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0),
        width: size.width * .3,
        child: Text(
          field,
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
      contents: Container(
        padding:
            const EdgeInsets.only(left: 8.0, top: 5.0, right: 8.0, bottom: 3),
        width: size.width * .7,
        // height: 20.0,
        child: isTimeToUpdate
            ? Row(
                children: [
                  Text(
                    '$value     ',
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.black,
                  ),
                ],
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
      ),
      node: TimelineNode(
        indicator: DotIndicator(
          color: nobColor,
          size: 10.0,
        ),
        startConnector: SolidLineConnector(color: nobColor),
        endConnector: SolidLineConnector(color: nobColor),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
