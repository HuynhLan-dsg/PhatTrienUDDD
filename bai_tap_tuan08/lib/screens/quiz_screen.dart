import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vocabulary.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() =>
      _QuizScreenState();
}

class _QuizScreenState
    extends State<QuizScreen> {

  List<Vocabulary> vocabularies = [];

  Vocabulary? currentWord;

  int correctCount = 0;

  int wrongCount = 0;

  final TextEditingController
      answerController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVocabulary();
  }

  Future<void> loadVocabulary() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    List<String> data =
        prefs.getStringList(
              'vocabulary',
            ) ??
            [];

    vocabularies = data.map((item) {

      List<String> parts =
          item.split('|');

      return Vocabulary(
        word: parts[0],
        meaning: parts[1],
      );
    }).toList();

    nextQuestion();
  }

  void nextQuestion() {

    if (vocabularies.isEmpty) {
      return;
    }

    Random random = Random();

    currentWord =
        vocabularies[
            random.nextInt(
              vocabularies.length,
            )];

    answerController.clear();

    setState(() {});
  }

  void checkAnswer() {

    if (currentWord == null) {
      return;
    }

    bool correct =
        answerController.text
                .trim()
                .toLowerCase() ==
            currentWord!
                .meaning
                .trim()
                .toLowerCase();

    if (correct) {

      correctCount++;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "Chính xác",
          ),
        ),
      );

    } else {

      wrongCount++;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.red,
          content: Text(
            "Sai! Đáp án đúng: "
            "${currentWord!.meaning}",
          ),
        ),
      );
    }

    nextQuestion();
  }

  @override
  Widget build(BuildContext context) {

    if (currentWord == null) {
      return const Center(
        child:
            Text("Chưa có dữ liệu"),
      );
    }

    return Padding(
      padding:
          const EdgeInsets.all(16),
      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,
            children: [

              Chip(
                backgroundColor:
                    Colors.green,
                label: Text(
                  "✓ $correctCount",
                ),
              ),

              Chip(
                backgroundColor:
                    Colors.orange,
                label: Text(
                  "✗ $wrongCount",
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 30,
          ),

          Text(
            currentWord!.word,
            style: const TextStyle(
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          TextField(
            controller:
                answerController,
            decoration:
                const InputDecoration(
              hintText:
                  "Nhập nghĩa",
              border:
                  OutlineInputBorder(),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          ElevatedButton(
            onPressed:
                checkAnswer,
            child:
                const Text(
              "Check",
            ),
          ),
        ],
      ),
    );
  }
}