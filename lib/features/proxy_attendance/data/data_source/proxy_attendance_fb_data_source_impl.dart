import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/proxy_attendance/data/data_source/proxy_attendance_fb_data_source.dart';
import 'package:my_office/features/proxy_attendance/data/model/proxy_attendance_model.dart';

class ProxyAttendanceFbDataSourceImpl implements ProxyAttendanceFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<Either<ErrorResponse, List<ProxyAttendanceModel>>>
      getStaffNames() async {
    List<ProxyAttendanceModel> allStaffs = [];

    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('staff').once();
    try {
      for (var uid in snapshot.snapshot.children) {
        var names = uid.value as Map<Object?, Object?>;
        final staffNames = ProxyAttendanceModel(
          uid: uid.key.toString(),
          department: names['department'].toString(),
          name: names['name'].toString(),
          profileImage: names['profileImage'].toString(),
          emailId: names['email'].toString(),
        );
        if(staffNames.name != 'Nikhil Deepak'){
          allStaffs.add(staffNames);
        }
      }
      return Right(allStaffs);
    } catch (e) {
      return Left(
        ErrorResponse(
          error: 'Error caught while getting staff names',
          metaInfo: 'Catch triggered while fetching staff names',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, bool>> checkInProxy({
  required String userId,
  required DateTime date,
  required DateTime initialTime,
  required String reason,
  required String proxyBy,
  }) async {
    try {
      String year = DateFormat('yyyy').format(date);
      String month = DateFormat('MM').format(date);
      String day = DateFormat('dd').format(date);
      String time = DateFormat('HH:mm:ss').format(initialTime);

      await ref.child('attendance/$year/$month/$day/$userId').update({
        'check_in': time,
      });
      await ref.child('attendance/$year/$month/$day/$userId/proxy_in').update({
          'reason': reason,
          'proxy_by': proxyBy,
      });
      return const Right(true);
    } catch (e) {
      return Left(
        ErrorResponse(
          error: 'Error caught while updating Proxy check-in',
          metaInfo: 'Catch triggered while updating Proxy check-in',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, bool>> checkOutProxy({
   required String userId,
   required DateTime date,
   required DateTime initialTime,
   required String reason,
   required String proxyBy,
  }) async {
    try {
      String year = DateFormat('yyyy').format(date);
      String month = DateFormat('MM').format(date);
      String day = DateFormat('dd').format(date);
      String time = DateFormat('HH:mm:ss').format(initialTime);

      await ref.child('attendance/$year/$month/$day/$userId').update({
        'check_out': time,
      });
      await ref.child('attendance/$year/$month/$day/$userId/proxy_out').update({
          'reason': reason,
          'proxy_by': proxyBy,
      });
      return const Right(true);
    } catch (e) {
      return Left(
        ErrorResponse(
          error: 'Error caught while updating Proxy check-out',
          metaInfo: 'Catch triggered while updating Proxy check-out',
        ),
      );
    }
  }
}
