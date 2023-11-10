import '../../data/model/pr_reminder_model.dart';

abstract class PrReminderRepository{
  Future<List<PrReminderModel>> getReminders(String selectedDate);

  Future<List<String>> getPRStaffNames();
}