import 'package:bai_tap_tuan_05/trangchu.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Trangchu(),
    );
  }
}