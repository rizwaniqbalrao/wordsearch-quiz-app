import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsProvider extends ChangeNotifier {
  int _puzzlesCompleted = 0;
  int _totalTimePlayed = 0; // seconds
  int _currentStreak = 0;
  int _bestStreak = 0;
  String _favoriteCategory = '';
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _timerVisible = true;
  bool _darkMode = false;

  int get puzzlesCompleted => _puzzlesCompleted;
  int get totalTimePlayed => _totalTimePlayed;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  String get favoriteCategory => _favoriteCategory;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get timerVisible => _timerVisible;
  bool get darkMode => _darkMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _puzzlesCompleted = prefs.getInt('puzzles_completed') ?? 0;
    _totalTimePlayed = prefs.getInt('total_time_played') ?? 0;
    _currentStreak = prefs.getInt('current_streak') ?? 0;
    _bestStreak = prefs.getInt('best_streak') ?? 0;
    _favoriteCategory = prefs.getString('favorite_category') ?? '';
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    _timerVisible = prefs.getBool('timer_visible') ?? true;
    _darkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> recordPuzzleCompleted({
    required String categoryName,
    required int timeTaken,
  }) async {
    _puzzlesCompleted++;
    _totalTimePlayed += timeTaken;
    _currentStreak++;
    if (_currentStreak > _bestStreak) {
      _bestStreak = _currentStreak;
    }

    // Track favorite category (most played)
    final prefs = await SharedPreferences.getInstance();
    final counts = <String, int>{};
    final raw = prefs.getString('category_counts') ?? '';
    if (raw.isNotEmpty) {
      for (final part in raw.split(',')) {
        final kv = part.split(':');
        if (kv.length == 2) counts[kv[0]] = int.tryParse(kv[1]) ?? 0;
      }
    }
    counts[categoryName] = (counts[categoryName] ?? 0) + 1;
    _favoriteCategory = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    await prefs.setString('category_counts',
        counts.entries.map((e) => '${e.key}:${e.value}').join(','));

    await prefs.setInt('puzzles_completed', _puzzlesCompleted);
    await prefs.setInt('total_time_played', _totalTimePlayed);
    await prefs.setInt('current_streak', _currentStreak);
    await prefs.setInt('best_streak', _bestStreak);
    await prefs.setString('favorite_category', _favoriteCategory);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', value);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', value);
    notifyListeners();
  }

  Future<void> setTimerVisible(bool value) async {
    _timerVisible = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('timer_visible', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  Future<void> resetStats() async {
    _puzzlesCompleted = 0;
    _totalTimePlayed = 0;
    _currentStreak = 0;
    _bestStreak = 0;
    _favoriteCategory = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('puzzles_completed');
    await prefs.remove('total_time_played');
    await prefs.remove('current_streak');
    await prefs.remove('best_streak');
    await prefs.remove('favorite_category');
    await prefs.remove('category_counts');
    notifyListeners();
  }

  String get formattedTotalTime {
    final hours = _totalTimePlayed ~/ 3600;
    final minutes = (_totalTimePlayed % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    if (minutes > 0) return '${minutes}m';
    return '${_totalTimePlayed}s';
  }
}
