import 'package:flutter/cupertino.dart';
import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';
import 'package:my_office/features/pr_reminder/domain/use_case/get_pr_reminders_use_case.dart';
import 'package:my_office/features/pr_reminder/domain/use_case/pr_reminder_staff_names_use_case.dart';

class PrReminderProvider extends ChangeNotifier {
  final GetPrRemindersCase _getPrRemindersCase;
  final PrReminderStaffNamesCase _prReminderStaffNamesCase;
  List<PrReminderModel> allReminders = [];
  List<String> staffNames = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PrReminderProvider(this._getPrRemindersCase, this._prReminderStaffNamesCase);

  void _setLoading(bool loading) {
    Future.microtask(() {
      _isLoading = loading;
      notifyListeners();
    });
  }


  Future<void> fetchPrReminders(String selectedDate) async {
    _setLoading(true);
    allReminders = await _getPrRemindersCase.execute(selectedDate);
    notifyListeners();
    _setLoading(false);
  }

  Future<void> fetchPrStaffNames() async {
    _setLoading(true);
    staffNames = await _prReminderStaffNamesCase.execute();
    _setLoading(false);
  }
}
