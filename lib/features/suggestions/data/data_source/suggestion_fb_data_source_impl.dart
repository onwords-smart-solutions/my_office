import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/suggestions/data/data_source/suggestion_fb_data_source.dart';

class SuggestionFbDataSourceImpl implements SuggestionFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<void> addSuggestion(String uid, String message) async {
    DateTime now = DateTime.now();
    var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);

    await ref.child('suggestion/$timeStamp').update({
      'date': DateFormat('yyyy-MM-dd').format(now),
      'message': message,
      'time': DateFormat('kk:mm').format(now),
      'isread': false,
      'uid': uid,
    });
  }
}
 