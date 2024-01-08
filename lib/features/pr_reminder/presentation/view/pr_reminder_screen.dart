import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  String names = 'My Reminders';
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
      subtitle: 'PR Reminders',
      templateBody: buildReminder(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildReminder() {
    final reminderProvider = Provider.of<PrReminderProvider>(context);
    List<PrReminderModel> filteredReminders = names == 'All Reminders'
        ? reminderProvider.allReminders
        : reminderProvider.allReminders
            .where((element) => element.updatedBy == names)
            .toList();

    if (names == 'All Reminders') {
      filteredReminders = reminderProvider.allReminders;
    } else if (names == 'My Reminders') {
      filteredReminders = reminderProvider.allReminders
          .where((element) => element.updatedBy == widget.staffInfo.name)
          .toList();
    } else {
      filteredReminders = reminderProvider.allReminders
          .where((element) => element.updatedBy == names)
          .toList();
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
                  color: Theme.of(context).primaryColor,
                  size: height * 0.04,
                ),
              ),
              SizedBox(width: width * 0.03),
              Text(
                '$selectedDate',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          'Total reminders : ${filteredReminders.length}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Gap(10),
        reminderProvider.isLoading
            ? Expanded(
                child: Center(
                  child: Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
                  Lottie.asset('assets/animations/loading_light_theme.json'):
                  Lottie.asset('assets/animations/loading_dark_theme.json'),
                ),
              )
            : filteredReminders.isNotEmpty
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
                                  color: Theme.of(context).primaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    CupertinoIcons.person_2_fill,
                                    color: Theme.of(context).primaryColor,
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
                                            surfaceTintColor: Colors.transparent,
                                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                            title: Text(
                                              'Do you want to delete the reminder?',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                               color: Theme.of(context).primaryColor,
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
                                                child: TextButton(
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context).primaryColor,
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
                                                child: TextButton(
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color:Theme.of(context).primaryColor,
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
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Theme.of(context).primaryColor,
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/no_data.json',
                              height: 300.0,
                            ),
                            Text(
                              'No reminders set😞',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
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
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
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
                  child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                  ),
                );
              }).toList();
            },
            icon: Icon(
                CupertinoIcons.sort_down, color: Theme.of(context).primaryColor,),
          ),
          Text(
            names,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
