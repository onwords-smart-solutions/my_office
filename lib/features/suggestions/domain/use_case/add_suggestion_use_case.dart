import 'package:my_office/features/suggestions/domain/repository/suggestion_repository.dart';

class AddSuggestionCase {
  final SuggestionRepository suggestionRepository;

  AddSuggestionCase({required this.suggestionRepository});

  Future<void> execute(String uid, String message) async {
    return suggestionRepository.addSuggestion(uid, message);
  }
}
