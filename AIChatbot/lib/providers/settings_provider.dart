import 'package:flutter/material.dart';
import 'package:chatbotapp/hive/boxes.dart';
import 'package:chatbotapp/hive/settings.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _shouldSpeak = false;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get shouldSpeak => _shouldSpeak;
  bool get isInitialized => _isInitialized;

  Future<void> getSavedSettings() async {
    final settingsBox = Boxes.getSettings();

    if (settingsBox.isNotEmpty) {
      final settings = settingsBox.getAt(0);
      if (settings != null) {
        _isDarkMode = settings.isDarkTheme;
        _shouldSpeak = settings.shouldSpeak;
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  void toggleDarkMode({required bool value, Settings? settings}) {
    if (settings != null) {
      settings.isDarkTheme = value;
      settings.save();
    } else {
      final settingsBox = Boxes.getSettings();
      settingsBox.put(
        0,
        Settings(isDarkTheme: value, shouldSpeak: shouldSpeak),
      );
    }

    _isDarkMode = value;
    notifyListeners();
  }

  void toggleSpeak({required bool value, Settings? settings}) {
    if (settings != null) {
      settings.shouldSpeak = value;
      settings.save();
    } else {
      final settingsBox = Boxes.getSettings();
      settingsBox.put(
        0,
        Settings(isDarkTheme: isDarkMode, shouldSpeak: value),
      );
    }

    _shouldSpeak = value;
    notifyListeners();
  }
}
