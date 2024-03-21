
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source.dart';

import '../model/expense_model.dart';
import '../model/income_model.dart';

class FinanceFbDataSourceImpl implements FinanceFbDataSource {
  final ref = FirebaseDatabase.instance.ref('FinancialAnalyzing');

  int parseAmount(String amountStr) {
    String numericStr = amountStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(numericStr);
  }

  @override
  Future <List<ExpenseModel>> getExpenseData(String selectedYear, String selectedMonth) async {
      DatabaseEvent event = await ref.child('Expense').once();
    List<ExpenseModel> expenseList = [];
    int total = 0;

    for (var check in event.snapshot.children) {
      if (selectedYear == check.key) {
        for (var monthData in check.children) {
          if (selectedMonth == monthData.key) {
            for (var dateData in monthData.children) {
              final data = dateData.value as Map<Object?, Object?>;
              final expenseDetails = ExpenseModel(
                amount: parseAmount(data['Amount'].toString()),
                enteredBy: data['EnteredBy'].toString(),
                enteredDate: data['EnteredDate'].toString(),
                enteredTime: data['EnteredTime'].toString(),
                productName: data['ProductName'].toString(),
                purchasedDate: data['PurchasedDate'].toString(),
                purchasedFor: data['PurchasedFor'].toString(),
                purchasedTime: data['PurchasedTime'].toString(),
                service: data['Service'].toString(),
              );
              expenseList.add(expenseDetails);
              total += parseAmount(data['Amount'].toString());
            }
          }
        }
      }
    }
    expenseList.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
    return expenseList;
  }

  @override
  Future<List<IncomeModel>> getIncomeData(String selectedYear, String selectedMonth) async {

    DatabaseEvent event = await ref.child('Income').once();
    List<IncomeModel> incomeList = [];
    int total = 0;

    for (var check in event.snapshot.children) {
      if (selectedYear == check.key) {
        for (var monthData in check.children) {
          if (selectedMonth == monthData.key) {
            for (var dateData in monthData.children) {
              final data = dateData.value as Map<Object?, Object?>;
              final incomeDetails = IncomeModel(
                amount: parseAmount(data['Amount'].toString()),
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
              incomeList.add(incomeDetails);
              total += parseAmount(data['Amount'].toString());
            }
          }
        }
      }
    }
    incomeList.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));
    return incomeList;
  }

}
