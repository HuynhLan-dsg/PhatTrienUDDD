import 'package:flutter/material.dart';
import 'video_recorder.dart';
import 'contacts_screen.dart';
import 'audio_player.dart';
import 'sms_analyzer.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Bài tập tuần 06',
        theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
        home: const MyApp(),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <String, Widget>{
      'Bài 4: Video Recorder & Playback': const VideoRecorderHome(),
      'Bài 5: Danh bạ': const ContactsListScreen(),
      'Bài 6: Audio Player (lớp + về nhà)': const AudioPlayerHome(),
      'Bài 7: SMS Analyzer': const SmsAnalyzerHome(),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập tuần 06')),
      body: ListView(
        children: items.entries
            .map((e) => ListTile(
                  title: Text(e.key),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => e.value)),
                ))
            .toList(),
      ),
    );
  }
}