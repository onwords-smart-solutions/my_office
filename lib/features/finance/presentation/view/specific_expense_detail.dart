import 'package:flutter/material.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_screen_template.dart';
import '../../data/model/expense_model.dart';

class ExpenseDetails extends StatefulWidget {
  final ExpenseModel expenseDetails;

  const ExpenseDetails({Key? key, required this.expenseDetails})
      : super(key: key);

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildExpenseDetailsScreen(),
      title: 'Expense Details',
    );
  }

  Widget buildExpenseDetailsScreen() {
    return Center(
      child: Column(
        children: [
          buildExpenseTable(),
        ],
      ),
    );
  }

  Widget buildExpenseTable() {
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
                  widget.expenseDetails.amount.toString(),
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
                  widget.expenseDetails.enteredBy.toString(),
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
                  widget.expenseDetails.enteredDate.toString(),
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
                  widget.expenseDetails.enteredTime.toString(),
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
                  widget.expenseDetails.productName.toString(),
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
                  "Purchased Date",
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
                  widget.expenseDetails.purchasedDate.toString(),
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
                  "Purchased For",
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
                  widget.expenseDetails.purchasedFor.toString(),
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
                  "Purchased Time",
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
                  widget.expenseDetails.purchasedTime.toString(),
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
                  "Service",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.expenseDetails.service.toString(),
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
