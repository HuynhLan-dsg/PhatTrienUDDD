// import 'package:bai_tap_tuan08/models/vocabulary.dart';
// import 'package:bai_tap_tuan08/services/vocabulary_services.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VocabularyScreen extends StatefulWidget
// {
//   const VocabularyScreen({super.key});

//   @override
//   State<VocabularyScreen> createState() => _VocabularyScreenState();
// }

// class _VocabularyScreenState extends State<VocabularyScreen>
// {
//   final TextEditingController wordController = TextEditingController();
//   final TextEditingController meanController = TextEditingController();

//   List<Vocabulary> vocabulary_list = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadVocabulary();
//   }

//   Future<void> loadVocabulary() async{
//     final prefs = await SharedPreferences.getInstance();
//     List<String> data = prefs.getStringList('vocabulary_list',)??[];

//     vocabulary_list = data.map((item)
//     {
//       List<String> parts = item.split('|');
//       return Vocabulary(word: parts[0], meaning: parts[1],);
//     }).toList();

//     setState(() {
      
//     });
//   }

//   Future<void> saveVocabulary() async{
//     final prefs = await SharedPreferences.getInstance();

//     List<String> data = vocabulary_list.map((v)
//     {
//       return '${v.word}| ${v.meaning}';
//     }).toList();

//     await prefs.setStringList('vocabulary_list', data,);
//   }

//   Future<void> addVocabulary() async
//   {
//     if(wordController.text.trim().isEmpty)
//     {
//       return;
//     }

//     if(meanController.text.trim().isEmpty)
//     {
//       return;
//     }

//     Vocabulary voca = Vocabulary(word: wordController.text.trim(), meaning: meanController.text.trim(),);

//     vocabulary_list.add(voca);

//     await saveVocabulary();

//     await VocabularyServices.instance.scheduleVocabularyNotification(id: vocabulary_list.length, word: voca.word,);

//     wordController.clear();
//     meanController.clear();

//     setState(() {
      
//     });
//   }

//   Future<void> deleteVocabulary
//   (int index) async
//   {
//     vocabulary_list.removeAt(index);
//     await saveVocabulary();
//     setState(() {
      
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Học từ vựng"),
//       ),
//       body: Padding(padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [
//           TextField(
//             controller: wordController,
//             decoration: const InputDecoration(
//               labelText: 'Từ tiếng anh',
//               border: OutlineInputBorder(),
//             ),
//           ),

//           const SizedBox(height: 10,),
//           TextField(
//             controller: meanController,
//             decoration: const InputDecoration(
//               labelText: 'nghĩa tiếng việt',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 10,),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(onPressed: addVocabulary, child: const Text('Lưu từ vựng',)),
//           ),

//           SizedBox(height: 20,),

//           Expanded(child: ListView.builder(
//             itemCount: vocabulary_list.length,
//             itemBuilder: (context, index) {
//               Vocabulary v = vocabulary_list[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(
//                     v.word,
//                   ),
//                   subtitle: Text(v.meaning),
//                   trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red,), onPressed: () {
//                     deleteVocabulary(index);
//                   },),
//                 ),
//               );
//             },
//           ))
//         ],
//       ),
//       ),
//     );
//   }
// }