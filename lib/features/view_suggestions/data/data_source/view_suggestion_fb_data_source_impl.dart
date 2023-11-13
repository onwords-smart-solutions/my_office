import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/view_suggestions/data/data_source/view_suggestion_fb_data_source.dart';

class ViewSuggestionsFbDataSourceImpl implements ViewSuggestionsFbDataSource {
  final ref = FirebaseDatabase.instance.ref('suggestion');

  @override
  Future<List<Map<Object?, Object?>>> getSuggestions() async {
    DatabaseEvent suggest = await ref.once();
    List<Map<Object?, Object?>> suggestions = [];
    for (var data in suggest.snapshot.children) {
      final newSuggestion = data.value as Map<Object?, Object?>;
      suggestions.add(newSuggestion);
    }
    return suggestions;
  }
}
