import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/constants/app_main_template.dart';
import 'package:my_office/features/finance/data/model/income_model.dart';
import 'package:my_office/features/finance/presentation/view/specific_income_detail.dart';
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
    return MainTemplate(
      templateBody: buildIncomeScreen(),
      subtitle: 'Income',
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildIncomeScreen() {
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
                  style: TextStyle(
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
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  widget.allIncome[index].amount.toString(),
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
