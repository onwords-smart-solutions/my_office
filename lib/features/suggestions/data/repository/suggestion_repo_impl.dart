import 'package:my_office/features/suggestions/data/data_source/suggestion_fb_data_source.dart';
import 'package:my_office/features/suggestions/domain/repository/suggestion_repository.dart';

class SuggestionRepoImpl implements SuggestionRepository {
  final SuggestionFbDataSource suggestionFbDataSource;

  SuggestionRepoImpl(this.suggestionFbDataSource);

  @override
  Future<void> addSuggestion(String uid, String message) async {
    return suggestionFbDataSource.addSuggestion(uid, message);
  }
}
