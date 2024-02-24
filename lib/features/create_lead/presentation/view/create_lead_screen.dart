import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/create_lead/domain/entity/create_lead_entity.dart';
import 'package:my_office/features/create_lead/presentation/provider/create_lead_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/constants/app_main_template.dart';

class CreateLeads extends StatefulWidget {
  final String staffName;

  const CreateLeads({super.key, required this.staffName});

  @override
  State<CreateLeads> createState() => _CreateLeadsState();
}

class _CreateLeadsState extends State<CreateLeads> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController inquiredFor = TextEditingController();
  TextEditingController dataFetchedBy = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Create New lead',
      templateBody: buildCreateLeads(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildCreateLeads() {
    var size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.height * 0.02,
              vertical: size.width * 0.1,
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.1),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(.4),
                width: 2,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.02),
                      child: TextField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Phone number",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.02),
                      child: TextField(
                        controller: phoneNumber,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Email id",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.02),
                      child: TextField(
                        controller: emailId,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "City",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.02),
                      child: TextField(
                        controller: city,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Inquired for",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.02),
                      child: TextField(
                        controller: inquiredFor,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Data fetched by",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.02),
                      child: TextField(
                        controller: dataFetchedBy,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(),
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(40),
          AppButton(
              onPressed: submitForm,
              child: Text(
                'Create lead',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ),
        ],
      ),
    );
  }

  void submitForm() async {
    if (name.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter the customer name!!',
        context: context,
      );
    } else if (phoneNumber.text.trim().isEmpty ||
        phoneNumber.text.trim().length < 10) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter the customer mobile number correctly!!',
        context: context,
      );
    } else if (emailId.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter the customer mail address!!',
        context: context,
      );
    } else if (city.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter the customer city!!',
        context: context,
      );
    } else if (inquiredFor.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter the customer reason of enquiry!!',
        context: context,
      );
    } else if (dataFetchedBy.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter the data fetched detail!!',
        context: context,
      );
    } else {
      createLeadsInDb();
    }
  }

  void createLeadsInDb() async {
    final createNewLead = CreateLeadEntity(
      name: name.text.trim(),
      phoneNumber: phoneNumber.text.trim(),
      createdBy: widget.staffName,
      emailId: emailId.text.trim(),
      city: city.text.trim(),
      inquiredFor: inquiredFor.text.trim(),
      dataFetchedBy: dataFetchedBy.text.trim(),
    );
    final response = await Provider.of<CreateLeadProvider>(context, listen: false).createLead(createNewLead);
    if(response.isRight){
      if(!mounted) return;
      CustomSnackBar.showSuccessSnackbar(
        message: 'A new lead has been created successfully!!',
        context: context,
      );
      name.clear();
      phoneNumber.clear();
      emailId.clear();
      city.clear();
      inquiredFor.clear();
      dataFetchedBy.clear();
    }else{
      if (!mounted) return;
      CustomSnackBar.showErrorSnackbar(
        message: 'Error while creating new lead!!',
        context: context,
      );
    }
  }
}
