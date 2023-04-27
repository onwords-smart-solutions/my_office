import 'package:flutter/material.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'income_details.dart';
import 'income_model.dart';

class IncomeScreen extends StatefulWidget {
  final List<IncomeModel> allIncome;
  const IncomeScreen({Key? key, required this.allIncome}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {


  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildIncomeScreen(),
      title: 'Income',
    );
  }

  Widget buildIncomeScreen() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.allIncome.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IncomeDetails(
                  incomeDetails: widget.allIncome[index],
                ),
              ),
            );
          },
          title: Text(
            widget.allIncome[index].customerName,
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
                fontSize: 16),
          ),
          trailing: Text(
           '-   ${ widget.allIncome[index].amount.toString()}',
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