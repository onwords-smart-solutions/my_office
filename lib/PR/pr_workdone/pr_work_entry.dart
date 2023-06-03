import 'dart:core';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';
import '../../util/main_template.dart';

class PrWorkDone extends StatefulWidget {
  final String userId;
  final String staffName;

  const PrWorkDone(
      {Key? key, required this.userId, required this.staffName})
      : super(key: key);

  @override
  State<PrWorkDone> createState() => _PrWorkDoneState();
}

class _PrWorkDoneState extends State<PrWorkDone> {
  List<Map<Object?, Object?>> prPoints = [];
  final prDatabase = FirebaseDatabase.instance.ref('PRPoints');
  DateTime dateTime = DateTime.now();
  bool isLoading = true;

  prPointsEntry() {
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    var monthFormat = DateFormat('MM').format(dateTime);
    var yearFormat = DateFormat('yyyy').format(dateTime);

    callsController.clear();
    invoiceController.clear();
    messageController.clear();
    pointsController.clear();
    quoteController.clear();
    visitController.clear();

    prDatabase
        .child('${widget.userId}/$yearFormat/$monthFormat/$dateFormat')
        .once()
        .then((points) {
      var newPrPoints;
      try {
        newPrPoints = points.snapshot.value as Map<Object?, Object?>;

        callsController.text = newPrPoints['calls'].toString();
        invoiceController.text = newPrPoints['invoice'].toString();
        messageController.text = newPrPoints['message'].toString();
        pointsController.text = newPrPoints['points'].toString();
        quoteController.text = newPrPoints['quote'].toString();
        visitController.text = newPrPoints['visit'].toString();

      } catch (e) {log('$e');}
      setState(() {
        isLoading = false;
      });
    });
  }

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      dateTime = newDate;
    });
    prPointsEntry();
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController callsController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  TextEditingController quoteController = TextEditingController();
  TextEditingController visitController = TextEditingController();

  @override
  void initState() {
    prPointsEntry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      key: formKey,
      subtitle: 'Update your daily works here !!!',
      templateBody: prPointsScreen(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget prPointsScreen() {
    return Column(
      children: [
        currentDatePicker(),
        prData(),
        const SizedBox(height: 30),
        submitButton(),
      ],
    );
  }

  Widget currentDatePicker() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 190),
              child: FloatingActionButton.small(
                elevation: 10,
                backgroundColor: ConstantColor.backgroundColor,
                tooltip: 'Date Picker',
                onPressed: () {
                  datePicker();
                },
                child: const Icon(Icons.date_range, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              DateFormat('dd-MM-yyyy').format(dateTime),
              style: TextStyle(
                color: ConstantColor.headingTextColor,
                fontSize: 18,
                fontFamily: ConstantFonts.poppinsBold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget prData() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(10),
                color: ConstantColor.backgroundColor,
                width: 2,
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Calls",
                        style: TextStyle(
                          color: ConstantColor.headingTextColor,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: callsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.call),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Invoice",
                        style: TextStyle(
                          color: ConstantColor.headingTextColor,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: invoiceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.inventory),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Message",
                        style: TextStyle(
                          color: ConstantColor.headingTextColor,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: messageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.message_rounded),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Points",
                        style: TextStyle(
                          color: ConstantColor.headingTextColor,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: pointsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.point_of_sale_rounded),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Quote",
                        style: TextStyle(
                          color: ConstantColor.headingTextColor,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: quoteController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.request_quote_rounded),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Visit",
                        style: TextStyle(
                          color: ConstantColor.headingTextColor,
                          fontSize: 17,
                          fontFamily: ConstantFonts.poppinsMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: visitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.directions_walk_rounded),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget submitButton() {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          backgroundColor: ConstantColor.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          addPrPoints();
        },
        child: Text(
          'Update',
          style: TextStyle(
            color: ConstantColor.background1Color,
            fontSize: 17,
            fontFamily: ConstantFonts.poppinsMedium,
          ),
        ),
      ),
    );
  }

  void addPrPoints() async {
    var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
    var monthFormat = DateFormat('MM').format(dateTime);
    var yearFormat = DateFormat('yyyy').format(dateTime);

    await prDatabase.child(widget.userId).update({
      'name': widget.staffName
    });
      prDatabase.child('${widget.userId}/$yearFormat/$monthFormat/$dateFormat').update(
        {
          'calls': callsController.text.isEmpty ? 0 : int.parse( callsController.text.trim()),
          'invoice': invoiceController.text.isEmpty ? 0 : int.parse( invoiceController.text.trim()),
          'message': messageController.text.isEmpty ? 0 : int.parse( messageController.text.trim()),
          'points': pointsController.text.isEmpty ? 0 : int.parse( pointsController.text.trim()),
          'quote': quoteController.text.isEmpty ? 0 : int.parse( quoteController.text.trim()),
          'visit': visitController.text.isEmpty ? 0 : int.parse( visitController.text.trim()),
        },
      );
      final snackBar = SnackBar(
        content: Text(
          'Data has been submitted!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
