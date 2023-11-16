import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/finance/data/data_source/finance_fb_data_source.dart';
import 'package:my_office/features/finance/data/model/expense_model.dart';
import 'package:my_office/features/finance/data/model/income_model.dart';
import 'package:my_office/features/finance/domain/repository/finance_repository.dart';

class FinanceRepoImpl implements FinanceRepository{
  final FinanceFbDataSource financeFbDataSource;

  FinanceRepoImpl(this.financeFbDataSource);


  @override
  Future<List<ExpenseModel>> getExpenseDetails(String selectedYear, String selectedMonth) async {
    return await financeFbDataSource.getExpenseData(selectedYear, selectedMonth);
  }

  @override
  Future<List<IncomeModel>> getIncomeDetails(String selectedYear, String selectedMonth) async {
   return await financeFbDataSource.getIncomeData(selectedYear, selectedMonth);
  }

}