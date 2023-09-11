import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/leads/search_leads.dart';
import 'package:my_office/models/staff_model.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../models/reminder_model.dart';
import '../util/screen_template.dart';
import 'customer_detail_screen.dart';

class FullRemindersScreen extends StatefulWidget {
  final ReminderModel fullReminders;
  final StaffModel staffInfo;
  final List<String> prStaffs;

  const FullRemindersScreen(
      {super.key,
      required this.fullReminders,
      required this.staffInfo,
      required this.prStaffs});

  @override
  State<FullRemindersScreen> createState() => _FullRemindersScreenState();
}

class _FullRemindersScreenState extends State<FullRemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildReminderScreen(),
      title: 'Total Reminders',
    );
  }

  Widget buildReminderScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
            },
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(12),
              color: ConstantColor.backgroundColor,
              width: 1.5,
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Customer name",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.customerName,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "City",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.city,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Created by",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.createdBy,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Created date",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.createdDate,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Created time",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.createdTime,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Customer id",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.customerId,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Data fetched by",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.dataFetchedBy,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Email id",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.emailId,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Enquired for",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.enquiredFor,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Lead incharge",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.leadInCharge,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Phone number",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.phoneNumber,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Rating",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.rating,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "State",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.state,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Updated by",
                      style: TextStyle(
                        color: ConstantColor.headingTextColor,
                        fontSize: 14,
                        fontFamily: ConstantFonts.sfProBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.updatedBy,
                      style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 14,
                       
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        CupertinoButton(
          color: CupertinoColors.activeOrange,
          pressedOpacity: 0.5,
          borderRadius: BorderRadius.circular(20),
          child: Text(
            'Get leads',
            style: TextStyle(
              fontFamily: ConstantFonts.sfProBold,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchLeadsScreen(
                    staffInfo: widget.staffInfo,
                    query: widget.fullReminders.phoneNumber,
                    selectedStaff: widget.fullReminders.updatedBy),
              ),
            );
          },
        ),
      ],
    );
  }
}
