import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/features/finance/data/model/income_model.dart';
import '../../../../core/utilities/constants/app_color.dart';

class IncomeDetails extends StatefulWidget {
  final IncomeModel incomeDetails;

  const IncomeDetails({Key? key, required this.incomeDetails})
      : super(key: key);

  @override
  State<IncomeDetails> createState() => _IncomeDetailsState();
}

class _IncomeDetailsState extends State<IncomeDetails> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      templateBody: buildIncomeDetailsScreen(),
      subtitle: 'Income Details',
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildIncomeDetailsScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(50),
          buildIncomeTable(),
        ],
      ),
    );
  }

  Widget buildIncomeTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
        },
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(.3),
          width: 2,
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Amount",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.amount.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Customer Name",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.customerName.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Entered By",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.enteredBy.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Entered Date",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.enteredDate.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Entered Time",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.enteredTime.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Invoice Number",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.invoiceNumber.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Paid Date",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.paidDate.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Paid Time",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.paidTime.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Payment Method",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.paymentMethod.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
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
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Product Name",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.incomeDetails.productName.toString(),
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}