import 'package:my_office/features/view_suggestions/domain/repository/view_suggestion_repository.dart';

class ViewSuggestionsCase {
  final ViewSuggestionsRepository viewSuggestionsRepository;

  ViewSuggestionsCase({required this.viewSuggestionsRepository});

  Future<List<Map<Object?, Object?>>> execute() async {
    return viewSuggestionsRepository.getSuggestions();
  }
}
