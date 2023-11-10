import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';

abstract class PrReminderFbDataSource{
  Future<List<PrReminderModel>> getReminders(String selectedDate);

  Future<List<String>> getPRStaffNames();
}