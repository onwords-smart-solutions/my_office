import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';
import 'package:my_office/features/pr_reminder/presentation/provider/pr_reminder_provider.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';
import 'package:provider/provider.dart';

import '../../../../core/utilities/constants/app_main_template.dart';
import 'individual_reminders_screen.dart';

class ReminderScreen extends StatefulWidget {
  final UserEntity staffInfo;

  const ReminderScreen({super.key, required this.staffInfo});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isLoading = true;
  String names = 'All Reminders';
  final List<String> staffs = ['All Reminders', 'My Reminders'];

  DateTime now = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');
  String? selectedDate;

  //Date-picker for selecting reminders date
  datePicker() async {
    final provider = Provider.of<PrReminderProvider>(context, listen: false);
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
    provider.fetchPrReminders(selectedDate!);
  }

  @override
  void initState() {
    selectedDate = dateFormat.format(now);
    final prReminderProvider =
        Provider.of<PrReminderProvider>(context, listen: false);
    prReminderProvider.fetchPrReminders(selectedDate!);
    prReminderProvider.fetchPrStaffNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Look up your Reminders!',
      templateBody: buildReminder(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildReminder() {
    final reminderProvider = Provider.of<PrReminderProvider>(context);
    List<PrReminderModel> filteredReminders = names == 'All Reminders'
        ? reminderProvider.allReminders
        : reminderProvider.allReminders.where((element) => element.updatedBy == names).toList();

    if (names == 'All Reminders') {
      filteredReminders = reminderProvider.allReminders;
    } else {
      filteredReminders =
          reminderProvider.allReminders.where((element) => element.updatedBy == names).toList();
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Row(
            children: [
              buildStaffPopupButton(reminderProvider.staffNames, height, width),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: CupertinoColors.systemPurple,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          'Total reminders : ${filteredReminders.length}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        reminderProvider.isLoading
            ? Expanded(
                child: Center(
                  child: Lottie.asset(
                    "assets/animations/new_loading.json",
                  ),
                ),
              )
            :
        filteredReminders.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredReminders.length,
                        itemBuilder: (ctx, i) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColor.backGroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(0.0, 2.0),
                                      blurRadius: 8,
                                    ),
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
                                      color: CupertinoColors.destructiveRed,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Do you want to delete the reminder?',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: CupertinoColors.label,
                                              ),
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
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: CupertinoColors
                                                          .destructiveRed,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await FirebaseDatabase
                                                        .instance
                                                        .ref(
                                                          'customer_reminders/$selectedDate/${filteredReminders[i].phoneNumber}',
                                                        )
                                                        .remove();
                                                    if (!mounted) return;
                                                    Provider.of<
                                                        PrReminderProvider>(
                                                      context,
                                                      listen: false,
                                                    ).fetchPrReminders(
                                                      selectedDate!,
                                                    );
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
                                                  child: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color:
                                                          CupertinoColors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                    ),
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
                                    filteredReminders[i].customerName,
                                    style: const TextStyle(
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
                                          fullReminders: filteredReminders[i],
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
                          Lottie.asset(
                            'assets/animations/no_data.json',
                            height: 300.0,
                          ),
                          const Text(
                            'No reminders set😞',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ],
    );
  }

  Widget buildStaffPopupButton(
      List<String> staffNames, double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Row(
        children: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            position: PopupMenuPosition.under,
            elevation: 10,
            onSelected: (String value) {
              setState(() {
                names = value;
              });
            },

            itemBuilder: (BuildContext ctx) {
              return staffNames.map((String name) {
                return PopupMenuItem<String>(
                  value: name,
                  child: Text(name, style: const TextStyle(fontSize: 16)),
                );
              }).toList();
            },
            icon: const Icon(CupertinoIcons.sort_down),
          ),
          Text(
            names,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          // ... the rest of your row
        ],
      ),
    );
  }
}
