import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/util/theme_type.dart';
import './theme_local_data_source.dart';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final _themeKey = 'THEME_MODE';

  @override
  Future<String> getCurrentAppTheme() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_themeKey) ?? ThemeType.system;
  }

  @override
  Future<void> resetAppTheme() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(_themeKey);
  }

  @override
  Future<void> updateAppTheme({required String theme}) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_themeKey, theme);
  }
}
