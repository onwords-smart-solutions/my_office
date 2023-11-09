import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/finance/domain/entity/expense_entity.dart';
import 'package:my_office/features/finance/presentation/view/specific_expense_detail.dart';

import '../../../../core/utilities/constants/app_screen_template.dart';

class ExpenseScreen extends StatefulWidget {
  final List<ExpenseEntity> allExpense;

  const ExpenseScreen({Key? key, required this.allExpense}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  bool ascending = false;

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildExpenseScreen(),
      title: 'Expense',
    );
  }

  Widget buildExpenseScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue.withOpacity(0.3),
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const Icon(
                  Icons.arrow_downward,
                  color: Colors.black,
                  size: 20,
                ),
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.black,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(
                  '-   ${widget.allExpense[index].amount.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColor.backGroundColor,
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
