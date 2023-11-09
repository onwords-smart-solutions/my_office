import 'package:my_office/features/finance/domain/entity/expense_entity.dart';
import 'package:my_office/features/finance/domain/entity/income_entity.dart';

abstract class FinanceFbDataSource{
  Future<List<IncomeEntity>> getIncomes(String year, String month);
  Future<List<ExpenseEntity>> getExpenses(String year, String month);
}