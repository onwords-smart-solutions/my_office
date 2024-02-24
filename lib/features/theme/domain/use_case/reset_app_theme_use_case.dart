import '../repository/theme_repository.dart';

class ResetAppThemeUseCase {
  final ThemeRepository themeRepository;

  ResetAppThemeUseCase({required this.themeRepository});

  Future<void> execute() async => await themeRepository.resetAppTheme();
}
