import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _service = TaskService();

  List<ToiletTask> tasks = [];
  bool loading = false;

  Timer? _pollTimer;
  String? _cleanerId;

  // -----------------------------
  // START POLLING (30 sec)
  // -----------------------------
  void start(String cleanerId) {
    // prevent duplicate polling
    if (_cleanerId == cleanerId && _pollTimer != null) return;

    _cleanerId = cleanerId;

    // first fetch immediately
    fetchTasks();

    // poll every 30 seconds
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchTasks(),
    );
  }

  // -----------------------------
  // STOP POLLING
  // -----------------------------
  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  // -----------------------------
  // FETCH TASKS
  // -----------------------------
  Future<void> fetchTasks() async {
    if (_cleanerId == null) return;

    try {
      loading = true;
      notifyListeners();

      tasks = await _service.getTasksForCleaner(_cleanerId!);
    } catch (e) {
      debugPrint("Task fetch error: $e");
    }

    loading = false;
    notifyListeners();
  }
}
