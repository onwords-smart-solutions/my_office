import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Constant/colors/constant_colors.dart';
import '../util/main_template.dart';

class ViewFoodCount extends StatefulWidget {
  const ViewFoodCount({Key? key}) : super(key: key);

  @override
  State<ViewFoodCount> createState() => _ViewFoodCountState();
}

class _ViewFoodCountState extends State<ViewFoodCount> {
  List<Map<Object?, Object?>> fullFoodCount = [];
  final foodCount = FirebaseDatabase.instance.ref('refreshments');

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      selectedMonth = formatterDate.format(newDate);
      selectedYear = formatterDate.format(newDate);
    });
  }

  finalFoodCount() {
    var year = selectedDate.toString().split('-').first;
    var month = selectedDate.toString().split('-')[1];
    fullFoodCount.clear();
    List<Map<Object?, Object?>> finalCount = [];
    foodCount.child('{$year/$month/').once().then((food){
      for (var check in food.snapshot.children){
        final data = check.value as Map<Object?, Object?>;
        log('data is $data');
      }
    });
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    finalFoodCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Entire Food Count!!',
      templateBody: buildFoodCountSection(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildFoodCountSection() {
    return Column(
      children: [
        Text('hello'),
      ],
    );
  }
}
