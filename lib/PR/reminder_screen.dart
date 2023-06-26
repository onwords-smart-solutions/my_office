import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/reminder_model.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';
import 'full_reminders_screen.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<ReminderModel> allReminders = [];
  bool isLoading = true;

  //Function for accessing the customer reminders db
  void getReminders() {
    allReminders.clear();
    final ref = FirebaseDatabase.instance.ref('customer_reminders/$selectedDate/');
    ref.once().then((data) {
      for (var customer in data.snapshot.children) {
        final allData = customer.value as Map<Object?, Object?>;
        final customerDetails = ReminderModel(
          city: allData['City'].toString(),
          createdBy: allData['Created_by'].toString(),
          createdDate: allData['Created_date'].toString(),
          createdTime: allData['Created_time'].toString(),
          customerId: allData['Customer_id'].toString(),
          customerName: allData['Customer_name'].toString(),
          dataFetchedBy: allData['Data_fetched_by'].toString(),
          emailId: allData['Email_id'].toString(),
          enquiredFor: allData['Enquired_for'].toString(),
          leadInCharge: allData['Lead_in_charge'].toString(),
          phoneNumber: allData['Phone_number'].toString(),
          rating: allData['Rating'].toString(),
          state: allData['State'].toString(),
          updatedBy: allData['Updated_by'].toString(),
        );
        allReminders.add(customerDetails);
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  DateTime now = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');
  String? selectedDate;
  //Date-picker for selecting reminders date
  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = dateFormat.format(newDate);
      },
    );
    getReminders();
  }

  @override
  void initState() {
    selectedDate = dateFormat.format(now);
    getReminders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
        subtitle: 'Look up your Reminders!',
        templateBody: buildReminder(),
        bgColor: ConstantColor.background1Color);
  }

  Widget buildReminder() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  datePicker();
                },
                child: Icon(
                  CupertinoIcons.calendar_badge_plus,
                  color: CupertinoColors.activeOrange,
                  size: height * 0.04,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '$selectedDate',
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 17,
                  color: CupertinoColors.systemPurple,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text('Total reminders : ${allReminders.length}',
          style: TextStyle(
            fontSize: 17,
            fontFamily: ConstantFonts.poppinsRegular,
            fontWeight: FontWeight.w600,
          ),
        ),
        isLoading ?
        Expanded(
          child: Center(
            child: Lottie.asset(
              "assets/animations/new_loading.json",
            ),
          ),
        ) : allReminders.isNotEmpty ?
        ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: allReminders.length,
              itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: ConstantColor.background1Color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(-0.0, 5.0),
                          blurRadius: 8,
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        CupertinoIcons.person_2_fill,
                        color: CupertinoColors.systemPurple,
                      ),
                      title: Text(
                        allReminders[i].customerName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: ConstantFonts.poppinsRegular,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullRemindersScreen(
                              fullReminders: allReminders[i],
                            ),
                          ),
                        );
                      },
                    ),
                  );
              },
            )
            : Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/no_data.json',
                    height: 300.0),
                Text(
                  'No reminders saved!!',
                  style: TextStyle(
                    color: ConstantColor.blackColor,
                    fontSize: 20,
                    fontFamily: ConstantFonts.poppinsRegular,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
