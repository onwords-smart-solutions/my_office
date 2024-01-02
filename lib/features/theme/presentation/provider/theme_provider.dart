import 'package:flutter/material.dart';
import 'dart:async';

import '../../domain/use_case/get_app_theme_use_case.dart';
import '../../domain/use_case/reset_app_theme_use_case.dart';
import '../../domain/use_case/update_app_theme_use_case.dart';
import '../util/theme_type.dart';

class ThemeProvider extends ChangeNotifier {
  final GetAppThemeUseCase _getAppThemeUseCase;
  final ResetAppThemeUseCase _resetAppThemeUseCase;
  final UpdateAppThemeUseCase _updateAppThemeUseCase;

  ThemeProvider(
    this._getAppThemeUseCase,
    this._resetAppThemeUseCase,
    this._updateAppThemeUseCase,
  );

  Timer? _timer;

  String _theme = ThemeType.system;
  bool _isDark = false;

  String get theme => _theme;

  bool get isDark => _isDark;

  ThemeMode get themeMode {
    switch (_theme) {
      case ThemeType.system:
        return ThemeMode.system;
      case ThemeType.auto:
        if (_isDark) {
          return ThemeMode.dark;
        } else {
          return ThemeMode.light;
        }
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.light:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  // Updating app theme
  Future<void> updateAppTheme(String theme) async {
    _setTheme(theme);
    await _updateAppThemeUseCase.execute(theme: theme);
  }

  // Loading theme form local DB when app launch
  Future<void> loadThemeFromLocal() async {
    final theme = await _getAppThemeUseCase.execute();
    _setTheme(theme);
  }

  // Clearing provider data
  Future<void> clearAppTheme() async {
    _theme = ThemeType.system;
    _isDark = false;
    await _resetAppThemeUseCase.execute();
    notifyListeners();
  }

  // PRIVATE FUNCTIONS
  void _checkAndChangeTheme() {
    final currentTime = DateTime.now();
    if (currentTime.hour >= 18 || currentTime.hour <= 5) {
      _isDark = true;
      notifyListeners();
    } else {
      _isDark = false;
      notifyListeners();
    }
  }

  Future<void> _setTheme(String theme) async {
    _theme = theme;
    if (theme == ThemeType.auto) {
      _checkAndChangeTheme();
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _checkAndChangeTheme();
      });
    } else {
      if (_timer != null) {
        _timer!.cancel();
      }
    }

    notifyListeners();
  }
}
