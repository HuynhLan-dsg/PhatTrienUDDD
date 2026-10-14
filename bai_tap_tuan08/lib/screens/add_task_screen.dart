import 'package:flutter/material.dart';

import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() =>
      _AddTaskScreenState();
}

class _AddTaskScreenState
    extends State<AddTaskScreen> {
  final TextEditingController titleController =
      TextEditingController();

  TimeOfDay? selectedTime;

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void saveTask() {
    if (titleController.text.trim().isEmpty ||
        selectedTime == null) {
      return;
    }

    final task = Task(
      title: titleController.text.trim(),
      reminderTime:
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
      completed: false,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Thêm nhiệm vụ mới"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(
                hintText:
                    "Tên nhiệm vụ",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              readOnly: true,
              onTap: pickTime,
              decoration: InputDecoration(
                hintText: selectedTime == null
                    ? "Giờ nhắc"
                    : selectedTime!.format(
                        context),
                border:
                    const OutlineInputBorder(),
                suffixIcon: const Icon(
                  Icons.access_time,
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: saveTask,
              child: const Text(
                "Lưu nhiệm vụ",
              ),
            ),
          ],
        ),
      ),
    );
  }
}