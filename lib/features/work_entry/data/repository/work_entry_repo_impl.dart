import 'package:my_office/features/work_entry/data/data_source/work_entry_fb_data_source.dart';
import 'package:my_office/features/work_entry/data/model/work_entry_model.dart';
import 'package:my_office/features/work_entry/domain/repository/work_entry_repository.dart';

class WorkEntryRepoImpl implements WorkEntryRepository {
  final WorkEntryFbDataSource workEntryFbDataSource;

  WorkEntryRepoImpl({required this.workEntryFbDataSource});

  @override
  Future<void> createNewWork(
    String userId,
    String year,
    String month,
    String date,
    WorkEntryRecord record,
  ) async {
    return await workEntryFbDataSource.createNewWork(
      userId,
      year,
      month,
      date,
      record,
    );
  }

  @override
  Future<List<WorkEntryRecord>> getWorkDone(
    String userId,
    String year,
    String month,
    String date,
  ) async {
    return await workEntryFbDataSource.getWorkDone(
      userId,
      year,
      month,
      date,
    );
  }
}
