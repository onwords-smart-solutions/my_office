import 'package:flutter/material.dart';
import 'package:my_office/features/finance/domain/entity/income_entity.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_screen_template.dart';

class IncomeDetails extends StatefulWidget {
  final IncomeEntity incomeDetails;

  const IncomeDetails({Key? key, required this.incomeDetails})
      : super(key: key);

  @override
  State<IncomeDetails> createState() => _IncomeDetailsState();
}

class _IncomeDetailsState extends State<IncomeDetails> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildIncomeDetailsScreen(),
      title: 'Income Details',
    );
  }

  Widget buildIncomeDetailsScreen() {
    return Center(
      child: Column(
        children: [
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
          color: AppColor.primaryColor,
          width: 1.5,
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Amount",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Customer Name",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Entered By",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Entered Date",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Entered Time",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Invoice Number",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Paid Date",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Paid Time",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Payment Method",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Product Name",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: AppColor.primaryColor,
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