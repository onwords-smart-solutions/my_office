import '../repository/theme_repository.dart';

class UpdateAppThemeUseCase {
  final ThemeRepository themeRepository;

  UpdateAppThemeUseCase({required this.themeRepository});

  Future<void> execute({required String theme}) async => await themeRepository.updateAppTheme(theme: theme);
}
