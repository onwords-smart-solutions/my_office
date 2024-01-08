import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/features/finance/data/model/expense_model.dart';
import 'package:my_office/features/finance/presentation/view/specific_expense_detail.dart';

class ExpenseScreen extends StatefulWidget {
  final List<ExpenseModel> allExpense;

  const ExpenseScreen({Key? key, required this.allExpense}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  bool ascending = false;

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      templateBody: buildExpenseScreen(),
      subtitle: 'Expense',
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildExpenseScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor.withOpacity(.3),
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                if (ascending) {
                  widget.allExpense
                      .sort((a, b) => a.amount.compareTo(b.amount));
                } else {
                  widget.allExpense
                      .sort((a, b) => b.amount.compareTo(a.amount));
                }
                ascending = !ascending;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ascending ? 'Ascending' : 'Descending',
                  style:  TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
                 Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                 Icon(
                  Icons.arrow_upward,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.allExpense.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExpenseDetails(
                        expenseDetails: widget.allExpense[index],
                      ),
                    ),
                  );
                },
                title: Text(
                  widget.allExpense[index].productName,
                  style:  TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  widget.allExpense[index].amount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
