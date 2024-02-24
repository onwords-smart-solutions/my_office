abstract class ThemeLocalDataSource{
  Future<String> getCurrentAppTheme();

  Future<void> updateAppTheme({required String theme});

  Future<void> resetAppTheme();
}