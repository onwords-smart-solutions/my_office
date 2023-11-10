import 'package:my_office/features/pr_reminder/data/data_source/pr_reminder_fb_data_source.dart';
import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';
import 'package:my_office/features/pr_reminder/domain/repository/pr_reminder_repository.dart';

class PrReminderRepoImpl implements PrReminderRepository{
  final PrReminderFbDataSource prReminderFbDataSource;

  PrReminderRepoImpl(this.prReminderFbDataSource);

  @override
  Future<List<String>> getPRStaffNames() async {
    return await prReminderFbDataSource.getPRStaffNames();
  }

  @override
  Future<List<PrReminderModel>> getReminders(String selectedDate) async{
    return await prReminderFbDataSource.getReminders(selectedDate);
  }

}