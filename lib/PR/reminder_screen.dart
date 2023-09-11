import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/models/reminder_model.dart';
import 'package:my_office/models/staff_model.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/main_template.dart';
import 'full_reminders_screen.dart';

class ReminderScreen extends StatefulWidget {
  final StaffModel staffInfo;

  const ReminderScreen({super.key, required this.staffInfo});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<ReminderModel> reminders = [];
  List<ReminderModel> allReminders = [];
  bool isLoading = true;
  String names = 'My Reminders';
  final List<String> staffs = ['All Reminders', 'My Reminders'];

  //Function for accessing the customer reminders db
  void getReminders() {
    reminders.clear();
    allReminders.clear();
    final ref =
        FirebaseDatabase.instance.ref('customer_reminders/$selectedDate/');
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
    setState(
      () {
        selectedDate = dateFormat.format(newDate);
      },
    );
    getReminders();
  }

  //Fetching PR Staff Names from firebase database
  void getPRStaffNames() {
    final ref = FirebaseDatabase.instance.ref();
    ref.child('staff').once().then((staffSnapshot) {
      for (var data in staffSnapshot.snapshot.children) {
        var fbData = data.value as Map<Object?, Object?>;
        if (fbData['department'] == 'PR') {
          final name = fbData['name'].toString();
          staffs.add(name);
        }
      }

      if (!mounted) return;
      setState(() {

      });
    });
  }

  @override
  void initState() {
    selectedDate = dateFormat.format(now);
    getReminders();
    getPRStaffNames();
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
    if (names == 'All Reminders') {
      reminders = allReminders;
    } else if(names == 'My Reminders'){
      reminders = allReminders.where((element) => element.updatedBy == widget.staffInfo.name).toList();
    }
    else{
      reminders = allReminders.where((element) => element.updatedBy == names).toList();
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Row(
            children: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                position: PopupMenuPosition.under,
                elevation: 10,
                itemBuilder: (ctx) => List.generate(
                  staffs.length,
                  (i) {
                    return PopupMenuItem(
                      child: Text(
                        staffs[i],
                        style: TextStyle(
                           
                            fontSize: 16),
                      ),
                      onTap: () {
                        setState(() {
                          names = staffs[i];
                        });
                      },
                    );
                  },
                ),
                icon: const Icon(CupertinoIcons.sort_down),
              ),
              Text(
                names,
                style: TextStyle(
                    fontFamily: ConstantFonts.sfProRegular,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
              const Spacer(),
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
              SizedBox(width: width * 0.03),
              Text(
                '$selectedDate',
                style: TextStyle(
                  fontFamily: ConstantFonts.sfProBold,
                  fontSize: 17,
                  color: CupertinoColors.systemPurple,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          'Total reminders : ${reminders.length}',
          style: TextStyle(
            fontSize: 18,
            fontFamily: ConstantFonts.sfProBold,
          ),
        ),
        isLoading
            ? Expanded(
                child: Center(
                  child: Lottie.asset(
                    "assets/animations/new_loading.json",
                  ),
                ),
              )
            : reminders.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reminders.length,
                        itemBuilder: (ctx, i) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ConstantColor.background1Color,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(0.0, 2.0),
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
                                  trailing: CupertinoButton(
                                    pressedOpacity: 0.5,
                                    child: const Icon(
                                        CupertinoIcons.delete_solid,
                                        color: CupertinoColors.destructiveRed),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text(
                                              'Do you want to delete the reminder?',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily:
                                                      ConstantFonts.sfProMedium,
                                                  color: CupertinoColors.label),
                                            ),
                                            actions: [
                                              Container(
                                                height: height * 0.05,
                                                width: width * 0.2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: MaterialButton(
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            ConstantFonts
                                                                .sfProBold,
                                                        color: CupertinoColors
                                                            .destructiveRed),
                                                  ),
                                                  onPressed: () async {
                                                    await FirebaseDatabase
                                                        .instance
                                                        .ref(
                                                            'customer_reminders/$selectedDate/${reminders[i].phoneNumber}')
                                                        .remove();
                                                    getReminders();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              Container(
                                                height: height * 0.05,
                                                width: width * 0.2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: MaterialButton(
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontFamily:
                                                            ConstantFonts
                                                                .sfProBold,
                                                        fontSize: 17),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  title: Text(
                                    reminders[i].customerName,
                                    style: TextStyle(
                                      fontSize: 17,
                                     
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullRemindersScreen(
                                          staffInfo: widget.staffInfo,
                                          fullReminders: reminders[i],
                                              prStaffs: staffs,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/no_data.json',
                              height: 300.0),
                          Text(
                            'No reminders set😞',
                            style: TextStyle(
                              color: ConstantColor.blackColor,
                              fontSize: 20,
                              fontFamily: ConstantFonts.sfProRegular,
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
