import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/finance/expense.dart';
import 'package:my_office/finance/income_details.dart';
import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
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

  DateTime now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterMonth = DateFormat('MM');
  var formatterYear = DateFormat('yyyy');
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (newDate == null) return;
    setState(() {
      selectedDate = formatterDate.format(newDate);
      selectedMonth = formatterDate.format(newDate);
      selectedYear = formatterDate.format(newDate);
      checkIncomeDetails(
          today.year.toString(), today.month.toString());
    });
  }

  @override
  void initState() {
    selectedDate = formatterDate.format(now);
    selectedMonth = formatterMonth.format(now);
    selectedYear = formatterYear.format(now);
    checkIncomeDetails(
        today.year.toString(), today.month.toString());
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  allIncome.clear();
                  datePicker();
                },
                child: Image.asset(
                  'assets/calender.png',
                  scale: 3,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '$selectedDate',
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 17,
                  color: ConstantColor.backgroundColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        allIncome.isNotEmpty
            ? Expanded(
                child: ListView.builder(
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
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        allIncome[index].customerName,
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            color: ConstantColor.blackColor,
                            fontSize: 17),
                      ),
                    );
                  },
                ),
              )
            : Expanded(
                child: Center(
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
                ),
              ),
      ],
    );
  }

  checkIncomeDetails(String year, String month) {

    var year = selectedDate.toString().split('-').first;
    var month = selectedDate.toString().split('-')[1];
    allIncome.clear();
    List<IncomeModel> incomeCheck = [];
    incomeDetails.child('Income/$year/$month').once().then((income) {
      for (var check in income.snapshot.children) {
        final data = check.value as Map<Object?, Object?>;
        final key = check.key.toString().split('_').first;
        if (key == selectedDate){
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
      setState(() {
        allIncome.addAll(incomeCheck);
      });
    });
  }
}
