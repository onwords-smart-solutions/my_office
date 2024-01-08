import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';
import '../../../../core/utilities/constants/app_color.dart';
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
    return MainTemplate(
      templateBody: buildReminderScreen(),
      subtitle: widget.fullReminders.customerName,
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildReminderScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor.withOpacity(.3),
                width: 2,
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
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.customerName,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "City",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.city,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Created by",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.createdBy,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Created date",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.createdDate,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Created time",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.createdTime,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Customer id",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.customerId,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Data fetched by",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.dataFetchedBy,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Email id",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.emailId,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Enquired for",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.enquiredFor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Lead incharge",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.leadInCharge,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Phone number",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.phoneNumber,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Rating",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.rating,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "State",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.state,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Updated by",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectableText(
                        widget.fullReminders.updatedBy,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(50),
          AppButton(
              onPressed: (){
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
              child: Text(
                'Get leads',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                  fontSize: 17,
                ),
              ),
          ),
        ],
      ),
    );
  }
}
