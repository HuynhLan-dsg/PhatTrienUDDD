import 'package:baitap_tuan4/bai01.dart';
import 'package:baitap_tuan4/bai02.dart';
import 'package:baitap_tuan4/bai03.dart';
import 'package:baitap_tuan4/bai04.dart';
import 'package:baitap_tuan4/bai05.dart';
import 'package:baitap_tuan4/bai06.dart';
import 'package:baitap_tuan4/demo.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bai06SC(),
    );
  }
}