import 'package:flutter/material.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'expense_details.dart';
import 'expense_model.dart';

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
          margin: EdgeInsets.symmetric(horizontal: 10),
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
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: ConstantFonts.sfProMedium),
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
              )),
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
                  style: TextStyle(
                      fontFamily: ConstantFonts.sfProMedium,
                      color: ConstantColor.blackColor,
                      fontSize: 16),
                ),
                trailing: Text(
                  '-   ${widget.allExpense[index].amount.toString()}',
                  style: TextStyle(
                      fontFamily: ConstantFonts.sfProBold,
                      color: ConstantColor.backgroundColor,
                      fontSize: 16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
