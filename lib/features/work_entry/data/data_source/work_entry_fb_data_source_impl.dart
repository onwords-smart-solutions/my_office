import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/work_entry/data/data_source/work_entry_fb_data_source.dart';
import 'package:my_office/features/work_entry/data/model/work_entry_model.dart';

class WorkEntryFbDataSourceImpl implements WorkEntryFbDataSource {
  final _workmanager = FirebaseDatabase.instance.ref('workmanager');

  @override
  Future<void> createNewWork(
    String userId,
    String year,
    String month,
    String date,
    WorkEntryRecord record,
  ) async {
    return await _workmanager
        .child(
          '$year/$month/$date/$userId/${record.startTime} to ${record.endTime}',
        )
        .set(record.toMap());
  }

  @override
  Future<List<WorkEntryRecord>> getWorkDone(
    String userId,
    String year,
    String month,
    String date,
  ) async {
    final snapshot =
        await _workmanager.child('$year/$month/$date/$userId').once();
    List<WorkEntryRecord> records = [];
    for (var loop in snapshot.snapshot.children) {
      var fbData = loop.value as Map<dynamic, dynamic>;
      records.add(WorkEntryRecord.fromMap(fbData));
    }
    return records;
  }
}
