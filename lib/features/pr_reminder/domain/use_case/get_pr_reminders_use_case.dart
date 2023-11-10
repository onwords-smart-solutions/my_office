import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';
import 'package:my_office/features/pr_reminder/domain/repository/pr_reminder_repository.dart';

class GetPrRemindersCase{
  final PrReminderRepository prReminderRepository;

  GetPrRemindersCase({required this.prReminderRepository});

  Future<List<PrReminderModel>> execute(String selectedDate) async{
    return await prReminderRepository.getReminders(selectedDate);
  }
}