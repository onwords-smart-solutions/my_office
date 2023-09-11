import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/util/main_template.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class CreateLeads extends StatefulWidget {
  final String staffName;
  const CreateLeads({super.key, required this.staffName});

  @override
  State<CreateLeads> createState() => _CreateLeadsState();
}

class _CreateLeadsState extends State<CreateLeads> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController inquiredFor = TextEditingController();
  TextEditingController dataFetchedBy = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Create new leads from here',
      templateBody: buildCreateLeads(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildCreateLeads() {
    var size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.height * 0.02, vertical: size.width * 0.1),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2.1),
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
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.height * 0.02),
                    child: TextField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      style: TextStyle( ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
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
                      "Phone number",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.height * 0.02),
                    child: TextField(
                      controller: phoneNumber,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      style: TextStyle( ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: ''
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
                      "Email id",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.height * 0.02),
                    child: TextField(
                      controller: emailId,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle( ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
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
                      "City",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.height * 0.02),
                    child: TextField(
                      controller: city,
                      keyboardType: TextInputType.text,
                      style: TextStyle( ),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
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
                      "Inquired for",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.height * 0.02),
                    child: TextField(
                      controller: inquiredFor,
                      keyboardType: TextInputType.text,
                      style: TextStyle( ),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
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
                      "Data fetched by",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.height * 0.02),
                    child: TextField(
                      controller: dataFetchedBy,
                      keyboardType: TextInputType.text,
                      style: TextStyle( ),
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        CupertinoButton(
          borderRadius: BorderRadius.circular(15),
          minSize: 20,
          color: CupertinoColors.systemPurple,
          onPressed: () {
            createLeadsInDb();
          },
          child: Text(
            'Create lead',
            style: TextStyle( ),
          ),
        ),
      ],
    );
  }

  void createLeadsInDb() async {
    var customerDb = FirebaseDatabase.instance.ref();
    if (name.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Enter the customer name!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,

          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if (phoneNumber.text.trim().isEmpty || phoneNumber.text.trim().length < 10) {
      final snackBar = SnackBar(
        content: Text(
          'Enter the customer mobile number correctly!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,

          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
   else if (emailId.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Enter the customer mail address!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,

          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
   else if (city.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Enter the customer city!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,

          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
   else if (inquiredFor.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Enter the customer reason of enquiry!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,

          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
   else if (dataFetchedBy.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Enter the data fetched detail!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,

          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      await customerDb.child('customer/${phoneNumber.text.trim()}').update({
        'name': name.text.trim(),
        'phone_number': phoneNumber.text.trim(),
        'email_id': emailId.text.trim(),
        'city': city.text.trim(),
        'inquired_for': inquiredFor.text.trim(),
        'data_fetched_by': dataFetchedBy.text.trim(),
        'LeadIncharge': 'Not Assigned',
        'rating': 0,
        'created_time': DateFormat('HH:mm:ss').format(DateTime.now()),
        'created_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'created_by': widget.staffName,
        'customer_state': 'New leads',
      });
      final snackBar = SnackBar(
        content: Text(
          'New leads has been created!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.sfProRegular,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      name.clear();
      phoneNumber.clear();
      emailId.clear();
      city.clear();
      inquiredFor.clear();
      dataFetchedBy.clear();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
