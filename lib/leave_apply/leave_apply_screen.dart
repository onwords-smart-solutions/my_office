import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';

class LeaveApplyScreen extends StatefulWidget {
  final String name;
  final String uid;
  const LeaveApplyScreen({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  TextEditingController leaveReason = TextEditingController();
  DateTime dateTime = DateTime.now();
  String? _reason;

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
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Apply for your leave here!!',
      templateBody: buildContent(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildContent(){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: height * 0.0,
          left: width * 0.0,
          right: width * 0.0,
          bottom: height * 0.05,
          child: Container(
            height: height * 0.95,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: ConstantColor.background1Color,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Stack(
              children: [
                Positioned(
                  top: height * 0.03,
                  left: width * 0.05,
                  right: width * 0.05,
                  // bottom: height * 0.5,
                  child: Container(
                    height: height * 0.43,
                    width: width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(-5.0, 5.0),
                            blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        textFieldWidget(
                            'Reason for leave...',
                            'Reason :',
                            leaveReason,
                            TextInputType.name,
                            TextInputAction.done),
                      ],
                    ),
                  ),
                ),

                /// Submit Button
                Positioned(
                  top: height * 0.55,
                  left: width * 0.05,
                  right: width * 0.05,
                  child: buttonWidget(
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget buttonWidget() {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
          addLeaveToDb();
      },
      child: Container(
        height: height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Submit',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.background1Color,
              fontSize: height * 0.028,
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
      String name,
      String title,
      TextEditingController textEditingController,
      TextInputType inputType,
      TextInputAction action) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDatePicker(),
          const SizedBox(height: 17),
          Text(
            title,
            style: TextStyle(
              color: ConstantColor.headingTextColor,
              fontFamily: ConstantFonts.poppinsBold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: TextFormField(
              controller: textEditingController,
              textInputAction: action,
              keyboardType: inputType,
              maxLines: 4,
              style: TextStyle(
                color: ConstantColor.blackColor,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
              decoration: InputDecoration(
                hintText: name,
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                    fontFamily: ConstantFonts.poppinsMedium),
                filled: true,
                fillColor: ConstantColor.background1Color,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          radioButtons(),
        ],
      ),
    );
  }

  Widget radioButtons() {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(
          width: width * 0.4,
          child: RadioListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title:
             Text("Sick", style: TextStyle(fontFamily: ConstantFonts.poppinsMedium)),
            value: "sick",
            groupValue: _reason,
            onChanged: (value) {
              setState(() {
                _reason = value.toString();
              });
            },
          ),
        ),
        SizedBox(
          width: width * 0.4,
          child: RadioListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title:
            Text("General", style: TextStyle(fontFamily: ConstantFonts.poppinsMedium)),
            value: "general",
            groupValue: _reason,
            onChanged: (value) {
              setState(() {
                _reason = value.toString();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    return  Row(
      children: [
        FloatingActionButton.small(
          elevation: 5,
          backgroundColor: ConstantColor.backgroundColor,
          tooltip: 'Date Picker',
          onPressed: () {
            datePicker();
          },
          child: const Icon(Icons.date_range, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          DateFormat('dd-MM-yyyy').format(dateTime),
          style: TextStyle(
            color: ConstantColor.headingTextColor,
            fontSize: 18,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void addLeaveToDb() async {
    if (leaveReason.text.trim().isEmpty) {
      final snackBar = SnackBar(
        content: Text(
          'Reason should be filled!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else if(_reason == null){
      final snackBar = SnackBar(
        content: Text(
          'Please fill the type for your leave Sick/General',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: ConstantFonts.poppinsMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      final leaveRef = FirebaseDatabase.instance.ref('leaveDetails');
      var dateFormat = DateFormat('yyyy-MM-dd').format(dateTime);
      var monthFormat = DateFormat('MM').format(dateTime);
      var yearFormat = DateFormat('yyyy').format(dateTime);
      leaveRef.child('${widget.uid}/leaveApplied/$yearFormat/$monthFormat/$dateFormat').update(
          {
            'date': DateFormat('yyyy-MM-dd').format(dateTime),
            'isapproved': 'processing',
            'reason': leaveReason.text.trim(),
            'type': _reason,
            'name': widget.name,
          }
      );
      final snackBar = SnackBar(
        content: Text(
          'Leave form has been submitted',
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
      leaveReason.clear();

    }
  }
}
