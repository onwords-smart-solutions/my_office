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

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildExpenseScreen(),
      title: 'Expense',
    );
  }

  Widget buildExpenseScreen() {
    return ListView.builder(
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
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
                fontSize: 16),
          ),
          trailing: Text(
            '-   ${widget.allExpense[index].amount.toString()}',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsBold,
                color: ConstantColor.backgroundColor,
                fontSize: 16),
          ),
        );
      },
    );

  }
}