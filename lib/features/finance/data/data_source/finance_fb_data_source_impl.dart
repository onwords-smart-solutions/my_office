import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source.dart';
import 'package:my_office/features/finance/domain/entity/expense_entity.dart';
import 'package:my_office/features/finance/domain/entity/income_entity.dart';

class FinanceFbDataSourceImpl implements FinanceFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<ExpenseEntity>> getExpenses(String year, String month) async {
    List<ExpenseEntity> expenses = [];
    DatabaseEvent event = await ref
        .child(
          'FinancialAnalyzing/Expense/$year/$month',
        )
        .once();
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final expenseData = value as Map<dynamic, dynamic>;
        final expense = ExpenseEntity(
          amount: int.parse(expenseData['Amount'].toString()),
          enteredBy: expenseData['EnteredBy'].toString(),
          enteredDate: expenseData['EnteredDate'].toString(),
          enteredTime: expenseData['EnteredTime'].toString(),
          productName: expenseData['ProductName'].toString(),
          purchasedDate: expenseData['PurchasedDate'].toString(),
          purchasedFor: expenseData['PurchasedFor'].toString(),
          purchasedTime: expenseData['PurchasedTime'].toString(),
          service: expenseData['Service'].toString(),
        );
        expenses.add(expense);
      });
    }
    log('Expense data are $expenses');
    return expenses;
  }

  @override
  Future<List<IncomeEntity>> getIncomes(String year, String month) async {
    List<IncomeEntity> incomes = [];
    DatabaseEvent event = await ref
        .child(
          'FinancialAnalyzing/Income/$year/$month',
        )
        .once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final incomeData = value as Map<dynamic, dynamic>;
        final income = IncomeEntity(
          amount: int.parse(incomeData['Amount'].toString()),
          customerName: incomeData['CustomerName'].toString(),
          enteredBy: incomeData['EnteredBy'].toString(),
          enteredDate: incomeData['EnteredDate'].toString(),
          enteredTime: incomeData['EnteredTime'].toString(),
          invoiceNumber: incomeData['InvoiceNumber'].toString(),
          paidDate: incomeData['PaidDate'].toString(),
          paidTime: incomeData['PaidTime'].toString(),
          paymentMethod: incomeData['PaymentMethod'].toString(),
          productName: incomeData['ProductName'].toString(),
        );
        incomes.add(income);
      });
    }
    log('Income data are $incomes');
    return incomes;
  }
}
