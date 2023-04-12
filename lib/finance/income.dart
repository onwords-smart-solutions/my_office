import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'income_details.dart';
import 'income_model.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  List<IncomeModel> allIncome = [];
  bool isLoading = true;
  final today = DateTime.now();
  DatabaseReference incomeDetails =
  FirebaseDatabase.instance.ref('FinancialAnalyzing');

  @override
  void initState() {
    checkIncomeDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildIncomeScreen(),
      title: 'Income',
    );
  }

  Widget buildIncomeScreen() {
    return isLoading
        ? Center(
      child: Lottie.asset(
        "assets/animations/loading.json",
      ),
    )
        : allIncome.isNotEmpty
        ? ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: allIncome.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IncomeDetails(
                  incomeDetails: allIncome[index],
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
            allIncome[index].paidDate,
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
            'No Income made!!',
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

  checkIncomeDetails() {
    allIncome.clear();
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
          }
        }
      }
      incomeCheck.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
      if (!mounted) return;
      setState(() {
        allIncome.addAll(incomeCheck);
        isLoading = false;
      });
    });
  }
}