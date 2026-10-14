import 'package:bai_tap_tuan08/screens/home_screen_todo.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding
      .ensureInitialized();

  await NotificationService
      .instance
      .init();

  runApp(
    const MyApp(),
  );
}

class MyApp
    extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner:
          false,
      home: HomeScreenToDo(),
    );
  }
}