import 'package:flutter/material.dart';
import 'package:bai_tap_tuan_07/Screen/map_screen.dart';
// import 'package:bai_tap_tuan_07/bai_tap_tailop.dart';
void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}