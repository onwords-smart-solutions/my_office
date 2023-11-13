import 'package:my_office/features/view_suggestions/data/data_source/view_suggestion_fb_data_source.dart';
import 'package:my_office/features/view_suggestions/domain/repository/view_suggestion_repository.dart';

class ViewSuggestionsRepoImpl implements ViewSuggestionsRepository{
  final ViewSuggestionsFbDataSource viewSuggestionsFbDataSource;

  ViewSuggestionsRepoImpl(this.viewSuggestionsFbDataSource);

  @override
  Future<List<Map<Object?, Object?>>> getSuggestions() async {
    List<Map<Object?, Object?>> suggestions = await viewSuggestionsFbDataSource.getSuggestions();
    suggestions.sort((a, b) => b['date'].toString().compareTo(a['date'].toString()));
    return suggestions;
  }

}