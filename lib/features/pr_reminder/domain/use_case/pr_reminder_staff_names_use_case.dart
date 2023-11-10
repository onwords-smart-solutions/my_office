import 'package:my_office/features/pr_reminder/domain/repository/pr_reminder_repository.dart';

class PrReminderStaffNamesCase{
  final PrReminderRepository prReminderRepository;

  PrReminderStaffNamesCase({required this.prReminderRepository});

  Future<List<String>> execute() async{
    return await prReminderRepository.getPRStaffNames();
  }
}