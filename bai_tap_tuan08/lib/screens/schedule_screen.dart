import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen
    extends StatefulWidget {

  const ScheduleScreen({
    super.key,
  });

  @override
  State<ScheduleScreen>
      createState() =>
          _ScheduleScreenState();
}

class _ScheduleScreenState
    extends State<
        ScheduleScreen> {

  List<String> schedules = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    schedules =
        prefs.getStringList(
              "vocabulary",
            ) ??
            [];

    setState(() {});
  }

  @override
  Widget build(
      BuildContext context) {

    return ListView.builder(
      itemCount:
          schedules.length,
      itemBuilder:
          (context, index) {

        final item =
            schedules[index];

        return ListTile(
          leading:
              const Icon(
            Icons.alarm,
          ),
          title:
              Text(item),
        );
      },
    );
  }
}