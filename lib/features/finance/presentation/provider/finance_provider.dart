import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/finance/domain/entity/expense_entity.dart';
import 'package:my_office/features/finance/domain/entity/income_entity.dart';
import 'package:my_office/features/finance/domain/use_case/finance_use_case.dart';

class FinanceProvider with ChangeNotifier {
  final FinanceCase _financeCase;
  bool _isLoading = true;
  List<IncomeEntity> _allIncome = [];
  List<ExpenseEntity> _allExpenses = [];
  int _totalIncome = 0;
  int _totalExpense = 0;

  late String _selectedDate;
  late String _selectedMonth;
  late String _selectedYear;

  String get selectedDate => _selectedDate;

  String get selectedMonth => _selectedMonth;

  String get selectedYear => _selectedYear;

  FinanceProvider(this._financeCase) {
    final now = DateTime.now();
    _selectedDate = DateFormat('yyyy-MM-dd').format(now);
    _selectedMonth = DateFormat('MM').format(now);
    _selectedYear = DateFormat('yyyy').format(now);
  }

  bool _isDataLoading = true; // Initial loading state
  bool get isLoading => _isDataLoading;

  List<IncomeEntity> get allIncome => _allIncome;

  List<ExpenseEntity> get allExpenses => _allExpenses;

  int get totalIncome => _totalIncome;

  int get totalExpense => _totalExpense;

  void updateSelectedDate(DateTime newDate) {
    _selectedDate = DateFormat('yyyy-MM-dd').format(newDate);
    _selectedMonth = DateFormat('MM').format(newDate);
    _selectedYear = DateFormat('yyyy').format(newDate);
    notifyListeners(); // This is crucial to inform the widgets of the update
    loadFinances(_selectedYear, _selectedMonth); // Trigger the data load for the new date
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_selectedDate),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != DateTime.parse(_selectedDate)) {
      updateSelectedDate(picked);
    }
  }

  void loadFinances(String year, String month) async {
    try {
      _isDataLoading = true;
      notifyListeners();

      _allIncome = await _financeCase.callIncomes(year, month);
      _totalIncome = _allIncome.fold(0, (sum, item) => sum + item.amount);

      _allExpenses = await _financeCase.callExpenses(year, month);
      _totalExpense = _allExpenses.fold(0, (sum, item) => sum + item.amount);

      _isDataLoading = false;
    } catch (e) {
      print('An error occurred while fetching finances: $e');
      _isDataLoading = false;
    }
    notifyListeners();
  }
}
