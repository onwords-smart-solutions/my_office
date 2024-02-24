abstract class ThemeRepository {
  Future<String> getCurrentAppTheme();

  Future<void> updateAppTheme({required String theme});

  Future<void> resetAppTheme();
}
