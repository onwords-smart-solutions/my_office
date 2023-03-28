import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildButton(
            name: 'Income',
            image: Image.asset(
              'assets/income.png',
              scale: 2,
            ),
            page:  const IncomeScreen(),
          ),
          buildButton(
            name: 'Expense',
            image: Image.asset(
              'assets/expense.png',
              scale: 2,
            ),
            page:  const ExpenseScreen(),
          ),
        ],
      ),
    );
  }
  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
            color: const Color(0xffDAD6EE),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(3.0,3.0),
                  blurRadius: 3
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: image),
            AutoSizeText(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
              ),
              minFontSize: 22,
            )
          ],
        ),
      ),
    );
  }

}
