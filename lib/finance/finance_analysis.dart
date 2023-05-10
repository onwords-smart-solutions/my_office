import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'expense.dart';
import 'expense_model.dart';
import 'income.dart';
import 'income_model.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  List<IncomeModel> allIncome = [];
  List<ExpenseModel> allExpense = [];

  bool isLoading = true;
  int totalIncome = 0;
  int totalExpense = 0;
  int totalSalary = 0;

  DatabaseReference incomeDetails =
      FirebaseDatabase.instance.ref('FinancialAnalyzing');
  DatabaseReference expenseDetails =
      FirebaseDatabase.instance.ref('FinancialAnalyzing');

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

  checkIncomeDetails1() {
    allIncome.clear();
    int total = 0;
    List<IncomeModel> incomeCheck = [];
    incomeDetails.child('Income').once().then((income) {
      for (var check in income.snapshot.children) {
        if (selectedYear == check.key) {
          for (var monthData in check.children) {
            if (selectedMonth == monthData.key) {
              for (var dateData in monthData.children) {
                final data = dateData.value as Map<Object?, Object?>;
                final incomeDetails = IncomeModel(
                  amount: int.parse(data['Amount'].toString()),
                  customerName: data['CustomerName'].toString(),
                  enteredBy: data['EnteredBy'].toString(),
                  enteredDate: data['EnteredDate'].toString(),
                  enteredTime: data['EnteredTime'].toString(),
                  invoiceNumber: data['InvoiceNumber'].toString(),
                  paidDate: data['PaidDate'].toString(),
                  paidTime: data['PaidTime'].toString(),
                  paymentMethod: data['PaymentMethod'].toString(),
                  productName: data['ProductName'].toString(),
                );
                incomeCheck.add(incomeDetails);
                total += int.parse(data['Amount'].toString());
              }
            }
          }
        }
      }
      incomeCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));

      if (!mounted) return;
      setState(() {
        allIncome.addAll(incomeCheck);
        totalIncome = total;
        isLoading = false;
      });
    });
  }

  checkExpenseDetails1() {
    allExpense.clear();
    int minus = 0;
    List<ExpenseModel> expenseCheck = [];
    expenseDetails.child('Expense').once().then((expense) {
      for (var check in expense.snapshot.children) {
        if (selectedYear == check.key) {
          for (var monthData in check.children) {
            if (selectedMonth == monthData.key) {
              for (var dateData in monthData.children) {
                final data = dateData.value as Map<Object?, Object?>;
                final expenseDetails = ExpenseModel(
                  amount: int.parse(data['Amount'].toString()),
                  enteredBy: data['EnteredBy'].toString(),
                  enteredDate: data['EnteredDate'].toString(),
                  enteredTime: data['EnteredTime'].toString(),
                  productName: data['ProductName'].toString(),
                  purchasedDate: data['PurchasedDate'].toString(),
                  purchasedFor: data['PurchasedFor'].toString(),
                  purchasedTime: data['PurchasedTime'].toString(),
                  service: data['Service'].toString(),
                );
                expenseCheck.add(expenseDetails);
                minus += int.parse(data['Amount'].toString());
              }
            }
          }
        }
      }
      expenseCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
      if (!mounted) return;
      setState(() {
        allExpense.addAll(expenseCheck);
        totalExpense = minus;
        isLoading = false;
        getTotalSalary();
      });
    });
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
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: profitWithSalary.toString(),
                                  style: TextStyle(
                                      color: profitWithSalary
                                              .toString()
                                              .contains('-')
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Profit without salary : ',
                            style: TextStyle(fontSize: 15, color: Colors.black),
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
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        datePicker();
                      },
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: - 2,
                          shadowLightColorEmboss: Colors.white.withOpacity(0.8),
                          shadowDarkColorEmboss: Colors.black.withOpacity(0.7),
                          shadowLightColor: Colors.white,
                          shadowDarkColor: Colors.black,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(20),
                          ),
                        ),
                        child: Container(
                          height: 50,
                          width: 100,
                          // decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                          //     borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '$selectedYear/$selectedMonth',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    )
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

  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 250,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
            color: const Color(0xffDAD6EE),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(3.0, 3.0),
                  blurRadius: 3)
            ]),
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
              minFontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

// checkIncomeDetails() {
//   allIncome.clear();
//   int total = 0;
//   List<IncomeModel> incomeCheck = [];
//   incomeDetails.child('Income').once().then((income) {
//     for (var check in income.snapshot.children) {
//       for (var monthData in check.children) {
//         for (var dateData in monthData.children) {
//           final data = dateData.value as Map<Object?, Object?>;
//           final incomeDetails = IncomeModel(
//             amount: int.parse(data['Amount'].toString()),
//             customerName: data['CustomerName'].toString(),
//             enteredBy: data['EnteredBy'].toString(),
//             enteredDate: data['EnteredDate'].toString(),
//             enteredTime: data['EnteredTime'].toString(),
//             invoiceNumber: data['InvoiceNumber'].toString(),
//             paidDate: data['PaidDate'].toString(),
//             paidTime: data['PaidTime'].toString(),
//             paymentMethod: data['PaymentMethod'].toString(),
//             productName: data['ProductName'].toString(),
//           );
//           incomeCheck.add(incomeDetails);
//           total += int.parse(data['Amount'].toString());
//         }
//       }
//     }
//     incomeCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
//
//     if (!mounted) return;
//     setState(() {
//       allIncome.addAll(incomeCheck);
//       totalIncome = total;
//       isLoading = false;
//     });
//   });
// }
//
// checkExpenseDetails() {
//   allExpense.clear();
//   int minus = 0;
//   List<ExpenseModel> expenseCheck = [];
//   expenseDetails.child('Expense').once().then((expense) {
//     for (var check in expense.snapshot.children) {
//       for (var monthData in check.children) {
//         for (var dateData in monthData.children) {
//           final data = dateData.value as Map<Object?, Object?>;
//           final expenseDetails = ExpenseModel(
//             amount: int.parse(data['Amount'].toString()),
//             enteredBy: data['EnteredBy'].toString(),
//             enteredDate: data['EnteredDate'].toString(),
//             enteredTime: data['EnteredTime'].toString(),
//             productName: data['ProductName'].toString(),
//             purchasedDate: data['PurchasedDate'].toString(),
//             purchasedFor: data['PurchasedFor'].toString(),
//             purchasedTime: data['PurchasedTime'].toString(),
//             service: data['Service'].toString(),
//           );
//           expenseCheck.add(expenseDetails);
//           minus += int.parse(data['Amount'].toString());
//         }
//       }
//     }
//     expenseCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
//     if (!mounted) return;
//     setState(() {
//       allExpense.addAll(expenseCheck);
//       totalExpense = minus;
//       isLoading = false;
//     });
//   });
// }
////////////////////////////

  int getTotalSalary() {
    // int totalSalary = 0;
    for (var x in allExpense) {
      if (x.service.toLowerCase() == 'salary') {
        totalSalary += x.amount;
      }
    }
    print(totalSalary);
    return totalSalary;
  }
}
