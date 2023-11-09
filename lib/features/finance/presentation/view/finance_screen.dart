import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/finance/presentation/view/expense_details.dart';
import 'package:my_office/features/finance/presentation/view/income_details.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../core/utilities/constants/app_screen_template.dart';
import '../../../home/presentation/view/home_screen.dart';
import '../provider/finance_provider.dart';
// ... other imports ...

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;
  int totalSalary = 0;

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterMonth = DateFormat('MM');
    var formatterYear = DateFormat('yyyy');
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanceProvider>(context, listen: false)
          .loadFinances(selectedYear!, selectedMonth!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final financeProvider = Provider.of<FinanceProvider>(context);

    return ScreenTemplate(
      bodyTemplate: buildFinanceScreen(financeProvider),
      title: 'Financial Analyzing',
    );
  }

  Widget buildFinanceScreen(financeProvider) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        int profitWithSalary = provider.totalIncome - provider.totalExpense;
        int profitWithOutSalary =
            provider.totalIncome - (provider.totalExpense - getTotalSalary());

        if (provider.isLoading) {
          return Center(
            child: Lottie.asset("assets/animations/new_loading.json"),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Profit with salary : ',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: profitWithSalary.toString(),
                                style: TextStyle(
                                  color:
                                      profitWithSalary.toString().contains('-')
                                          ? Colors.red
                                          : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Profit without salary : ',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: profitWithOutSalary.toString(),
                                style: TextStyle(
                                  color: profitWithOutSalary
                                          .toString()
                                          .contains('-')
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FilledButton.tonal(
                      onPressed: () => provider.selectDate(context),
                      child: SizedBox(
                        height: height * 0.05,
                        width: width * 0.17,
                        child: Center(
                          child: Text(
                            '$selectedYear/$selectedMonth',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                buildButton(
                  name: 'Income - ${provider.totalIncome}',
                  image: Image.asset(
                    'assets/income.png',
                    scale: 3,
                  ),
                  page: IncomeScreen(allIncome: provider.allIncome),
                ),
                buildButton(
                  name: 'Expense - ${provider.totalExpense}',
                  image: Image.asset(
                    'assets/expense.png',
                    scale: 3,
                  ),
                  page: ExpenseScreen(allExpense: provider.allExpenses),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildButton({
    required String name,
    required Image image,
    required Widget page,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: height * 0.3,
        width: width * 1,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xffDAD6EE),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(3.0, 3.0),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: image),
            Text(
              name,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getTotalSalary() {
    final provider =
        Provider.of<FinanceProvider>(context, listen: false).allExpenses;
    // int totalSalary = 0;
    for (var x in provider) {
      if (x.service.toLowerCase() == 'salary') {
        totalSalary += x.amount;
      }
    }
    print(totalSalary);
    return totalSalary;
  }
}
