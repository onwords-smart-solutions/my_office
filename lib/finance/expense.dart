import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'expense_details.dart';
import 'expense_model.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<ExpenseModel> allExpense = [];
  bool isLoading = true;
  final today = DateTime.now();
  DatabaseReference expenseDetails =
  FirebaseDatabase.instance.ref('FinancialAnalyzing');

  @override
  void initState() {
    checkExpenseDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildExpenseScreen(),
      title: 'Expense',
    );
  }

  Widget buildExpenseScreen() {
    return isLoading
        ? Center(
      child: Lottie.asset(
        "assets/animations/loading.json",
      ),
    )
        : allExpense.isNotEmpty
        ? ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: allExpense.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExpenseDetails(
                  expenseDetails: allExpense[index],
                ),
              ),
            );
          },
          leading: const CircleAvatar(
            radius: 20,
            backgroundColor: ConstantColor.backgroundColor,
            child: Icon(Icons.receipt_long),
          ),
          title: Text(
            allExpense[index].productName,
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
                fontSize: 17),
          ),
        );
      },
    )
        : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/no_data.json',
              height: 200.0),
          Text(
            'No Expense made!!',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: ConstantColor.blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  checkExpenseDetails() {
    allExpense.clear();
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
          }
        }
      }
      expenseCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
      if (!mounted) return;
      setState(() {
        allExpense.addAll(expenseCheck);
        isLoading = false;
      });
    });
  }
}