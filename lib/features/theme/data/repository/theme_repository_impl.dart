

import '../../domain/repository/theme_repository.dart';
import '../local_data_source/theme_local_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<String> getCurrentAppTheme() async => localDataSource.getCurrentAppTheme();

  @override
  Future<void> resetAppTheme() async => localDataSource.resetAppTheme();

  @override
  Future<void> updateAppTheme({required String theme}) async => localDataSource.updateAppTheme(theme: theme);
}
