import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import 'add_task_screen.dart';

class HomeScreenToDo extends StatefulWidget {
  const HomeScreenToDo({super.key});

  @override
  State<HomeScreenToDo> createState() =>
      _HomeScreenToDoState();
}

class _HomeScreenToDoState
    extends State<HomeScreenToDo> {
  List<Task> tasks = [];

  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks =
        await StorageService.loadTasks();

    completedCount = tasks
        .where((e) => e.completed)
        .length;

    setState(() {});
  }

  Future<void> addTask() async {
    final task =
        await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AddTaskScreen(),
      ),
    );

    if (task == null) {
      return;
    }

    tasks.add(task);

    await StorageService.saveTasks(
      tasks,
    );

    await NotificationService.instance
        .scheduleTaskNotification(
      id: tasks.length,
      taskTitle: task.title,
      reminderTime:
          task.reminderTime,
    );

    setState(() {});
  }

  Future<void> markCompleted(
      int index) async {
    bool? result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text("Xác nhận"),
          content: const Text(
            "Bạn đã hoàn thành nhiệm vụ này?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, false);
              },
              child: const Text(
                  "Không"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true);
              },
              child:
                  const Text("Có"),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    tasks[index].completed = true;

    completedCount++;

    await StorageService.saveTasks(
      tasks,
    );

    await NotificationService.instance
        .showCompletedNotification(
      completedCount,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nhiệm vụ mỗi ngày",
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder:
            (context, index) {
          final task = tasks[index];

          return Card(
            margin:
                const EdgeInsets.all(8),
            child: ListTile(
              leading: Checkbox(
                value: task.completed,
                onChanged:
                    task.completed
                        ? null
                        : (_) {
                            markCompleted(
                                index);
                          },
              ),
              title: Text(
                task.title,
              ),
              subtitle: Text(
                "Nhắc lúc ${task.reminderTime}",
              ),
              trailing: const Icon(
                Icons.notifications,
              ),
            ),
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: addTask,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}