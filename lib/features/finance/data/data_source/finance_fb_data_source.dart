import '../model/expense_model.dart';
import '../model/income_model.dart';

abstract class FinanceFbDataSource {
  Future<List<IncomeModel>> getIncomeData(
    String selectedYear,
    String selectedMonth,
  );

  Future<List<ExpenseModel>> getExpenseData(
    String selectedYear,
    String selectedMonth,
  );
}
