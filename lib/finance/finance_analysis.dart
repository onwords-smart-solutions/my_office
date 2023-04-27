import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isLoading = true;
  int totalIncome = 0;
  int totalExpense = 0;
  List<ExpenseModel> allExpense = [];
  DatabaseReference incomeDetails = FirebaseDatabase.instance.ref('FinancialAnalyzing');
  DatabaseReference expenseDetails = FirebaseDatabase.instance.ref('FinancialAnalyzing');


  @override
  void initState() {
    checkExpenseDetails();
    checkIncomeDetails();
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
    return isLoading ?
    Center(
      child: Lottie.asset(
        "assets/animations/new_loading.json",
      ),
    ):

    Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildButton(
            name: 'Income - $totalIncome',
            image: Image.asset(
              'assets/income.png',
              scale: 2,
            ),
            page: IncomeScreen(allIncome: allIncome),
          ),
          buildButton(
            name: 'Expense - $totalExpense',
            image: Image.asset(
              'assets/expense.png',
              scale: 2,
            ),
            page:  ExpenseScreen(allExpense: allExpense),
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
              minFontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  checkIncomeDetails() {
    allIncome.clear();
    int total = 0;
    List<IncomeModel> incomeCheck = [];
    incomeDetails.child('Income').once().then((income) {
      for (var check in income.snapshot.children) {
        for (var monthData in check.children) {
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
      incomeCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));


      if (!mounted) return;
      setState(() {
        allIncome.addAll(incomeCheck);
        totalIncome = total;
        isLoading = false;
      });
    });
  }

  checkExpenseDetails() {
    allExpense.clear();
    int minus = 0;
    List<ExpenseModel> expenseCheck = [];
    expenseDetails.child('Expense').once().then((expense) {
      for (var check in expense.snapshot.children) {
        for (var monthData in check.children) {
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
      expenseCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
      if (!mounted) return;
      setState(() {
        allExpense.addAll(expenseCheck);
        totalExpense = minus;
        isLoading = false;
      });
    });
  }
}
