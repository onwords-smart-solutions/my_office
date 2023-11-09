import 'package:my_office/features/finance/domain/entity/expense_entity.dart';
import 'package:my_office/features/finance/domain/entity/income_entity.dart';

import '../repository/finance_repository.dart';

class FinanceCase {
  final FinanceRepository financeRepository;

  FinanceCase({required this.financeRepository});

  Future<List<IncomeEntity>> callIncomes(String year, String month) {
    return financeRepository.fetchIncomes(year, month);
  }

  Future<List<ExpenseEntity>> callExpenses(String year, String month) {
    return financeRepository.fetchExpenses(year, month);
  }
}
