import '../../data/model/expense_model.dart';
import '../../data/model/income_model.dart';

abstract class FinanceRepository {
  Future<List<IncomeModel>> getIncomeDetails(
    String selectedYear,
    String selectedMonth,
  );

  Future<List<ExpenseModel>> getExpenseDetails(
    String selectedYear,
    String selectedMonth,
  );
}
