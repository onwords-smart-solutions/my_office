import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/customer_detail_screen.dart';
import 'package:timelines/timelines.dart';

import '../Constant/colors/constant_colors.dart';

class CustomerItem extends StatelessWidget {
  final Map<Object?, Object?> customerInfo;
  final String currentStaffName;

  const CustomerItem({Key? key, required this.customerInfo, required this.currentStaffName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String lastNote = 'Notes not updated';
    String lastNoteDate = '';

    if (customerInfo['notes'] != null) {
      //Getting all notes from customer data
      final Map<Object?, Object?> allNotes =
          customerInfo['notes'] as Map<Object?, Object?>;
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

    Color tileColor = Colors.white;
    Color nobColor = ConstantColor.backgroundColor;
    final size = MediaQuery.of(context).size;
    List<String> fields = [
      'Name',
      'Phone no',
      'Location',
      'Enquiry For',
      'Created date',
      'Lead in charge',
      'Status',
      'Note',
      'Note updated'
    ];
    List<String> values = [
      customerInfo['name'].toString(),
      customerInfo['phone_number'].toString(),
      customerInfo['city'].toString(),
      customerInfo['inquired_for'].toString(),
      customerInfo['created_date'].toString(),
      customerInfo['LeadIncharge'].toString(),
      customerInfo['customer_state'].toString(),
      lastNote,
      lastNoteDate,
    ];

    //Changing color based on customer state
    if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('rejected')) {
      tileColor = const Color(0xffF55F5F);
      nobColor = Colors.white60;
    } else if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('following up')) {
      tileColor = const Color(0xff91F291);
      nobColor = Colors.white60;
    } else if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('delayed')) {
      tileColor = const Color(0xffFFA500);
      nobColor = Colors.white60;
    } else if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('advanced')) {
      tileColor = const Color(0xfff1f7b5);
      nobColor = Colors.black38;
    } else if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('b2b')) {
      tileColor = const Color(0xff9ea1d4);
      nobColor = Colors.white;
    } else if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('under construction')) {
      tileColor = const Color(0xffa8d1d1);
      nobColor = Colors.black38;
    } else if (customerInfo['customer_state']
        .toString()
        .toLowerCase()
        .contains('installation completed')) {
      tileColor = const Color(0xff16f0b6);
      nobColor = Colors.white70;
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CustomerDetailScreen(customerInfo: customerInfo,containerColor: tileColor,nobColor: nobColor, currentStaffName: currentStaffName))),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: tileColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              buildField(
                  field: fields[0],
                  value: values[0],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[1],
                  value: values[1],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[2],
                  value: values[2],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[3],
                  value: values[3],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[4],
                  value: values[4],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[5],
                  value: values[5],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[6],
                  value: values[6],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[7],
                  value: values[7],
                  nobColor: nobColor,
                  size: size),
              buildField(
                  field: fields[8],
                  value: values[8],
                  nobColor: nobColor,
                  size: size),
            ],
          )),
    );
  }

  Widget buildField(
      {required String field,
      required String value,
      required Color nobColor,
      required Size size}) {
    return TimelineTile(
      nodePosition: .35,
      oppositeContents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0),
        width: size.width * .3,
        child: Text(
          field,
          style:
              TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 13.0),
        ),
      ),
      contents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0,right: 5.0),
        width: size.width * .7,
        // height: 20.0,
        child: Text(
          value,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium, fontSize: 13.0),
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
}
