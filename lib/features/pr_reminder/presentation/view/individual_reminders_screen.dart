import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_screen_template.dart';
import '../../../search_leads/presentation/view/customer_leads_screen.dart';
import '../../../user/domain/entity/user_entity.dart';

class FullRemindersScreen extends StatefulWidget {
  final PrReminderModel fullReminders;
  final UserEntity staffInfo;
  final List<String> prStaffs;

  const FullRemindersScreen({
    super.key,
    required this.fullReminders,
    required this.staffInfo,
    required this.prStaffs,
  });

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
              color: AppColor.primaryColor,
              width: 1.5,
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.grey.shade300,
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Customer name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.customerName,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "City",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.city,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Created by",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.createdBy,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Created date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.createdDate,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Created time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.createdTime,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Customer id",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.customerId,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Data fetched by",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.dataFetchedBy,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Email id",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.emailId,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Enquired for",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.enquiredFor,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Lead incharge",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.leadInCharge,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Phone number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.phoneNumber,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Rating",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.rating,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "State",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.state,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Updated by",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SelectableText(
                      widget.fullReminders.updatedBy,
                      style: TextStyle(
                        color: AppColor.primaryColor,
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
          child: const Text(
            'Get leads',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchLeadsScreen(
                  staffInfo: widget.staffInfo,
                  query: widget.fullReminders.phoneNumber,
                  selectedStaff: widget.fullReminders.updatedBy,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
