import 'package:firebase_database/firebase_database.dart';

class FirebaseOperation {
  Future<List<String>> getUserId({required List<String> userNames}) async {
    List<String> id = [];
    FirebaseDatabase.instance.ref('staff').once().then((value) {
      if (value.snapshot.exists) {
        for (var staff in value.snapshot.children) {
          final staffInfo = value.snapshot.value as Map<Object?, Object?>;
          if (userNames.contains(staffInfo['name'].toString())) {
            id.add(staff.key.toString());
          }
        }
      }
    });

    return id;
  }
}
