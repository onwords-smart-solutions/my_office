import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/work_details/data/data_source/work_detail_fb_data_source.dart';
import 'package:my_office/features/work_details/data/model/work_detail_model.dart';

class WorkDetailFbDataSourceImpl implements WorkDetailFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<WorkDoneModel>> getWorkDetails(DateTime selectedDate) async {
    List<WorkDoneModel> workDetails = [];

    // Format the selected date
    final formattedMonth = DateFormat('MM').format(selectedDate);
    final formattedDay = DateFormat('dd').format(selectedDate);
    final fullDateFormat = '${selectedDate.year}-$formattedMonth-$formattedDay';

    // Fetch staff data
    final staffRef = ref.child('staff');
    DatabaseEvent staffSnapshot = await staffRef.once();

    if (staffSnapshot.snapshot.exists) {
      for (var staff in staffSnapshot.snapshot.children) {
        List<WorkReport> staffWorkDone = [];
        final staffInfo = staff.value as Map<Object?, Object?>;
        final uid = staff.key;
        final name = staffInfo['name'].toString();
        final dept = staffInfo['department'].toString();
        final email = staffInfo['email'].toString();
        final url = staffInfo['profileImage']?.toString() ?? '';

        // Fetch work done by each staff
        final workRef = ref.child(
          'workmanager/${selectedDate.year}/$formattedMonth/$fullDateFormat/$uid',
        );
        DatabaseEvent workSnapshot = await workRef.once();

        if (workSnapshot.snapshot.exists) {
          for (var work in workSnapshot.snapshot.children) {
            final workInfo = work.value as Map<Object?, Object?>;
            staffWorkDone.add(
              WorkReport(
                from: workInfo['from'].toString(),
                to: workInfo['to'].toString(),
                duration: workInfo['time_in_hours'].toString(),
                workdone: workInfo['workDone'].toString(),
                percentage: workInfo['workPercentage'].toString(),
              ),
            );
          }
        }
        if(name != 'Nikhil Deepak'){
          workDetails.add(
            WorkDoneModel(
              name: name,
              department: dept,
              url: url,
              email: email,
              reports: staffWorkDone,
            ),
          );
        }
      }
    }
    return workDetails;
  }
}
