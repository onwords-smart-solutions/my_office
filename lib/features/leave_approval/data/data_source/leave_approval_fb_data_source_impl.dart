import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/leave_approval/data/data_source/leave_approval_fb_data_source.dart';
import 'package:my_office/features/leave_approval/data/model/leave_approval_model.dart';

class LeaveApprovalFbDataSourceImpl implements LeaveApprovalFbDataSource {
  final _ref = FirebaseDatabase.instance.ref();

  @override
  Future<int> checkLeaveStatus(String date) async {
    final splittedDate = date.split('-');
    int statusCount = 0;

    await _ref
        .child('leave_details/${splittedDate[0]}/${splittedDate[1]}/$date')
        .once()
        .then((value) {
      for (var staff in value.snapshot.children) {
        try {
          if (staff.child('general/status').value.toString() == 'Approved') {
            statusCount += 1;
          }
        } catch (e) {
          log('General error from $e');
        }
        try {
          if (staff.child('sick/status').value.toString() == 'Approved') {
            statusCount += 1;
          }
        } catch (e) {
          log('Sick error from $e');
        }
        try {
          if (staff.child('permission/status').value.toString() == 'Approved') {
            statusCount += 1;
          }
        } catch (e) {
          log('Permission error from $e');
        }
      }
    });
    log('Leave Count for $date is $statusCount');
    return statusCount;
  }

  @override
  Future<Either<ErrorResponse, bool>> updateLeaveRequest(
      StaffLeaveApprovalModel data
      ) async {
    try{
      await _ref.child('leave_details/${data.year}/${data.month}/${data.date}/${data.uid}/${data.type}').update({
        'updated_by': data.name,
        'status': data.status,
      });
      return const Right(true);
    }catch(e){
      return Left(
        ErrorResponse(
          error: 'Error caught while updating leave approval',
          metaInfo: 'Catch triggered while updating leave approval',
        ),
      );
    }
  }
}
