import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'expense.dart';
import 'income.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildFinanceScreen(),
      title: 'Financial Analyzing',
    );
  }

  Widget buildFinanceScreen() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ConstantColor.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const IncomeScreen(),
                ),
              );
            },
            child: Text(
              "Income",
              style: TextStyle(
                color: ConstantColor.background1Color,
                fontSize: 16,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ConstantColor.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExpenseScreen(),
                ),
              );
            },
            child: Text(
              "Expense",
              style: TextStyle(
                color: ConstantColor.background1Color,
                fontSize: 16,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
