import 'package:my_office/features/finance/data/data_source/finance_fb_data_source.dart';
import 'package:my_office/features/finance/domain/entity/expense_entity.dart';

import '../entity/income_entity.dart';

 class FinanceRepository {
   final FinanceFbDataSource _financeFbDataSource;

   FinanceRepository(this._financeFbDataSource);

   Future<List<IncomeEntity>> fetchIncomes(String year, String month) {
     return _financeFbDataSource.getIncomes(year, month);
   }

   Future<List<ExpenseEntity>> fetchExpenses(String year, String month) {
     return _financeFbDataSource.getExpenses(year, month);
   }
}