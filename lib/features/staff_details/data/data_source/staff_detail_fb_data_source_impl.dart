import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/staff_details/data/data_source/staff_detail_fb_data_source.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';

class StaffDetailFbDataSourceImpl implements StaffDetailFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<Either<ErrorResponse, bool>> removeStaffDetails(String uid) async {
    try {
      await ref.child('staff/$uid').remove();
      await ref.child('staff_details/$uid').remove();
      return const Right(true);
    } catch (e) {
      return Left(
        ErrorResponse(
          error: 'Error caught while removing staff details',
          metaInfo: 'Catch triggered while removing staff data',
        ),
      );
    }
  }

  @override
  Future<List<StaffDetailModel>> staffNames() async {
    final List<StaffDetailModel> allNames = [];
    ref.child('staff').once().then((values) {
      for (var uid in values.snapshot.children) {
        var names = uid.value as Map<Object?, Object?>;
        final staffNames = StaffDetailModel(
          uid: uid.key.toString(),
          department: names['department'].toString(),
          name: names['name'].toString(),
          profileImage: names['profileImage'].toString(),
          emailId: names['email'].toString(),
        );
        if (staffNames.name != 'Nikhil Deepak') {
          allNames.add(staffNames);
        }
      }
    });
    return allNames;
  }
}
