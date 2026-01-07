import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_history_model.dart';

class HistoryService {
  static const String _key = 'quiz_history';

  /// Save one quiz result
  static Future<void> saveHistory(QuizHistory history) async {
    final prefs = await SharedPreferences.getInstance();

    final String? raw = prefs.getString(_key);
    List list = raw == null ? [] : jsonDecode(raw);

    list.insert(0, history.toJson());

    await prefs.setString(_key, jsonEncode(list));
  }

  /// Get all quiz history
  static Future<List<QuizHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key);

    if (raw == null) return [];

    final List list = jsonDecode(raw);
    return list.map((e) => QuizHistory.fromJson(e)).toList();
  }

  /// Clear history (optional)
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
