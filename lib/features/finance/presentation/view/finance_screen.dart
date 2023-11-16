import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source_impl.dart';
import 'package:my_office/features/finance/data/repository/finance_repo_impl.dart';
import '../../../../core/utilities/constants/app_screen_template.dart';
import '../../data/model/expense_model.dart';
import '../../data/model/income_model.dart';
import '../../domain/repository/finance_repository.dart';
import 'expense_details.dart';
import 'income_details.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  List<IncomeModel> allIncome = [];
  List<ExpenseModel> allExpense = [];

  late FinanceFbDataSource financeFbDataSource = FinanceFbDataSourceImpl();
  late FinanceRepository financeRepository = FinanceRepoImpl(financeFbDataSource);

  bool isLoading = true;
  int totalIncome = 0;
  int totalExpense = 0;
  int totalSalary = 0;

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {
    totalSalary = 0;
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterDate.format(now);
    selectedYear = formatterDate.format(now);

    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    print(newDate);
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      selectedMonth = newDate.toString().substring(5, 7);
      selectedYear = newDate.toString().substring(0, 4);
      if (selectedDate != null) {
        checkIncomeDetails1();
        checkExpenseDetails1();
      }
    });
  }

  void checkIncomeDetails1() async {
    allIncome.clear();
    var incomeList = await financeRepository.getIncomeDetails(selectedYear!, selectedMonth!);
    setState(() {
      allIncome = incomeList;
      totalIncome = incomeList.fold(0, (sum, item) => sum + item.amount);
      isLoading = false;
    });
  }

  void checkExpenseDetails1() async {
    allExpense.clear();
    var expenseList = await financeRepository.getExpenseDetails(selectedYear!, selectedMonth!);
    setState(() {
      allExpense = expenseList;
      totalExpense = expenseList.fold(0, (sum, item) => sum + item.amount);
      isLoading = false;
    });
    getTotalSalary();
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    checkExpenseDetails1();
    checkIncomeDetails1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildFinanceScreen(),
      title: 'Financial Analyzing',
    );
  }

  Widget buildFinanceScreen() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    int profitWithSalary = 0;
    int profitWithOutSalary = 0;
    if (!isLoading) {
      profitWithSalary = totalIncome - totalExpense;
      profitWithOutSalary = totalIncome - (totalExpense - totalSalary);
      // getTotalSalary();
    }
    return isLoading
        ? Center(
            child: Lottie.asset(
              "assets/animations/new_loading.json",
            ),
          )
        : Padding(
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FilledButton.tonal(
                      onPressed: () {
                        datePicker();
                      },
                      child: SizedBox(
                        height: height * 0.05,
                        width: width * 0.17,
                        child: Center(
                          child: Text(
                            '$selectedYear/$selectedMonth',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                buildButton(
                  name: 'Income - $totalIncome',
                  image: Image.asset(
                    'assets/income.png',
                    scale: 3,
                  ),
                  page: IncomeScreen(allIncome: allIncome),
                ),
                buildButton(
                  name: 'Expense - $totalExpense',
                  image: Image.asset(
                    'assets/expense.png',
                    scale: 3,
                  ),
                  page: ExpenseScreen(allExpense: allExpense),
                ),
              ],
            ),
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
            AutoSizeText(
              name,
              style: const TextStyle(
                color: Colors.black,
              ),
              minFontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  int getTotalSalary() {
    // int totalSalary = 0;
    for (var x in allExpense) {
      if (x.service.toLowerCase() == 'salary') {
        totalSalary += x.amount;
      }
    }
    print('Total salary is $totalSalary');
    return totalSalary;
  }
}
