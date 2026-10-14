import 'package:bai_tap_tuan08/services/vocabulary_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vocabulary.dart';
// import '../services/notification_service.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() =>
      _LearnScreenState();
}

class _LearnScreenState
    extends State<LearnScreen> {

  final TextEditingController
      wordController =
      TextEditingController();

  final TextEditingController
      meaningController =
      TextEditingController();

  List<Vocabulary> vocabularies = [];

  @override
  void initState() {
    super.initState();
    loadVocabulary();
  }

  Future<void> loadVocabulary()
  async {
    final prefs =
        await SharedPreferences
            .getInstance();

    List<String> data =
        prefs.getStringList(
              'vocabulary',
            ) ??
            [];

    vocabularies =
        data.map((item) {

      List<String> parts =
          item.split('|');

      return Vocabulary(
        word: parts[0],
        meaning: parts[1],
      );
    }).toList();

    setState(() {});
  }

  Future<void> saveVocabulary()
  async {
    final prefs =
        await SharedPreferences
            .getInstance();

    List<String> data =
        vocabularies.map(
      (v) {
        return
            '${v.word}|${v.meaning}';
      },
    ).toList();

    await prefs.setStringList(
      'vocabulary',
      data,
    );
  }

  Future<void> addVocabulary()
  async {

    if (wordController.text
        .trim()
        .isEmpty) {
      return;
    }

    if (meaningController.text
        .trim()
        .isEmpty) {
      return;
    }

    Vocabulary vocabulary =
        Vocabulary(
      word:
          wordController.text
              .trim(),
      meaning:
          meaningController.text
              .trim(),
    );

    vocabularies.add(vocabulary);

    await saveVocabulary();

    await VocabularyServices
        .instance
        .scheduleVocabularyReminder(
      id: vocabularies.length,
      word: vocabulary.word,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã lưu và nhắc học sau 10 phút',
        ),
      ),
    );

    wordController.clear();
    meaningController.clear();

    setState(() {});
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ứng dụng học từ vựng',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          children: [

            TextField(
              controller:
                  wordController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Từ',
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextField(
              controller:
                  meaningController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nghĩa',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed:
                  addVocabulary,
              child: const Text(
                'Lưu & Nhắc học sau 10 phút',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child:
                  ListView.builder(
                itemCount:
                    vocabularies
                        .length,
                itemBuilder:
                    (
                  context,
                  index,
                ) {

                  Vocabulary v =
                      vocabularies[
                          index];

                  return Card(
                    child:
                        ListTile(
                      title: Text(
                        v.word,
                      ),
                      subtitle:
                          Text(
                        v.meaning,
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