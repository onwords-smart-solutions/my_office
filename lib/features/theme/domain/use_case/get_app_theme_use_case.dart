import '../repository/theme_repository.dart';

class GetAppThemeUseCase {
  final ThemeRepository themeRepository;

  GetAppThemeUseCase({required this.themeRepository});

  Future<String> execute() async => await themeRepository.getCurrentAppTheme();
}
