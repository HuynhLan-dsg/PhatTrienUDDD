import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';
import '../services/notification_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() =>
      _TodoScreenState();
}

class _TodoScreenState
    extends State<TodoScreen> {
  final TextEditingController controller =
      TextEditingController();

  DateTime? selectedDateTime;

  List<Todo> todos = [];

  @override
  //khởi động ngay khi màn hình mở lên lần đầu tiên
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {

    //Mở bộ nhớ điện thoại
    final prefs =
        await SharedPreferences.getInstance();

    //đọc dữ liệu bộ nhớ đó
    List<String> data =
        prefs.getStringList("todos") ?? [];

    //chuyển đổi dữ liệu
    todos = data.map((item) {
      //tách dữ liệu
      List<String> parts =
          item.split('|');

      return Todo(
        // tra về đổi tượng todo
        title: parts[0],
        dateTime:
            DateTime.parse(parts[1]),
      );
    }).toList();

    //vẽ lại giao diện khi dữ liệu đã đổi
    setState(() {});
  }

  //Lưu dữ liệu xuống máy
  Future<void> saveTodos() async {
    final prefs =
        await SharedPreferences.getInstance();

    //chuyển đổi dữ liệu thành string
    List<String> data = todos
        .map((todo) =>
            "${todo.title}|${todo.dateTime.toIso8601String()}")
        .toList();

    //Lưu xuống điện thoại
    await prefs.setStringList(
      "todos",
      data,
    );
  }

  //Chọn ngày giờ
  Future<void> pickDateTime() async {
    final date =
    //Hiện lịch
        await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time =
    //hiện đồng hồ
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.now(),
    );

    if (time == null) return;

    //ghép lại
    selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {});
  }

  //Lưu công việc
  Future<void> addTodo() async {
    //nếu như chưa nhập thì trả về 
    if (controller.text.isEmpty) {
      return;
    }

    //nếu như chưa chọn thì trả về
    if (selectedDateTime == null) {
      return;
    }

    //tạo todo
    Todo todo = Todo(
      title: controller.text,
      dateTime: selectedDateTime!,
    );

    //Thêm vào list
    todos.add(todo);

    //Lưu công việc
    await saveTodos();

    //đặt lịch thông báo
    await NotificationService
        .instance
        .scheduleNotification(
      id: todos.length,
      title: todo.title,
      datetime: todo.dateTime,
    );

    //xóa textfield hiển thị
    controller.clear();

    selectedDateTime = null;

    setState(() {});
  }

  //hàm xóa tại vị tri
  Future<void> deleteTodo(
      int index) async {
    todos.removeAt(index);

    await saveTodos();

    setState(() {});
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Todo App'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller:
                  controller,
              decoration:
                  const InputDecoration(
                hintText:
                    'Nhập công việc',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            SizedBox(
              width:
                  double.infinity,
              child: ElevatedButton(
                onPressed:
                    pickDateTime,
                child: Text(
                  selectedDateTime ==
                          null
                      ? "Chọn ngày giờ"
                      : selectedDateTime
                          .toString(),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            SizedBox(
              width:
                  double.infinity,
              child: ElevatedButton(
                onPressed: addTodo,
                child:
                    const Text(
                  "Lưu công việc",
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child:
                  ListView.builder(
                itemCount:
                    todos.length,
                itemBuilder:
                    (context,
                        index) {
                  Todo todo =
                      todos[index];

                  return Card(
                    child:
                        ListTile(
                      title: Text(
                        todo.title,
                      ),
                      subtitle:
                          Text(
                        todo
                            .dateTime
                            .toString(),
                      ),
                      trailing:
                          IconButton(
                        icon:
                            const Icon(
                          Icons
                              .delete,
                          color:
                              Colors
                                  .red,
                        ),
                        onPressed:
                            () {
                          deleteTodo(
                              index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}