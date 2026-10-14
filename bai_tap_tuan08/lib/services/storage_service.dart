import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class StorageService {
  static const String key = "tasks";

  /// Lưu danh sách nhiệm vụ
  static Future<void> saveTasks(
      List<Task> tasks) async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> data =
        tasks.map((task) {

      return "${task.title}"
          "|${task.reminderTime}"
          "|${task.completed}";
    }).toList();

    await prefs.setStringList(
      key,
      data,
    );
  }

  /// Đọc danh sách nhiệm vụ
  static Future<List<Task>>
      loadTasks() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> data =
        prefs.getStringList(key) ??
            [];

    return data.map((item) {

      List<String> parts =
          item.split("|");

      return Task(
        title: parts[0],
        reminderTime: parts[1],
        completed:
            parts[2] == "true",
      );

    }).toList();
  }
}