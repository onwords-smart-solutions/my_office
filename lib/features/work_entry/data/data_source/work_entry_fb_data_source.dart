
import '../model/work_entry_model.dart';

abstract class WorkEntryFbDataSource{

  Future<List<WorkEntryRecord>> getWorkDone(String userId, String year, String month, String date);

  Future<void> createNewWork(String userId, String year, String month, String date, WorkEntryRecord record);
}