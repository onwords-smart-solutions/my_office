import '../../data/model/work_entry_model.dart';

abstract class WorkEntryRepository {
  Future<List<WorkEntryRecord>> getWorkDone(
    String userId,
    String year,
    String month,
    String date,
  );

  Future<void> createNewWork(
    String userId,
    String year,
    String month,
    String date,
    WorkEntryRecord record,
  );
}
