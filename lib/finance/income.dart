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
  bool ascending = false;

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildIncomeScreen(),
      title: 'Income',
    );
  }

  Widget buildIncomeScreen() {
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
                    widget.allIncome.sort((a, b) => a.amount.compareTo(b.amount));
                  } else {
                    widget.allIncome.sort((a, b) => b.amount.compareTo(a.amount));
                  }
                  ascending = !ascending;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ascending ? 'Ascending' : 'Descending',
                    style: TextStyle(color: Colors.black,fontSize: 15, ),
                  ),
                  const Icon(Icons.arrow_downward,color: Colors.black,size: 20,),
                  const Icon(Icons.arrow_upward,color: Colors.black,size: 20,),

                ],
              )),
        ),
        Expanded(
          child: ListView.builder(
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

                      color: ConstantColor.blackColor,
                      fontSize: 16),
                ),
                trailing: Text(
                  '-   ${widget.allIncome[index].amount.toString()}',
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
