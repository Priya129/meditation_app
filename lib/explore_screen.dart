import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation/previous_screen.dart';

import 'detail_screen.dart';

extension DateTimeDayOfYear on DateTime {
  int get dayOfYear {
    return difference(DateTime(year, 1, 1)).inDays + 1;
  }
}

class RandomDailyQuestionScreen extends StatefulWidget {
  const RandomDailyQuestionScreen({super.key});

  @override
  _RandomDailyQuestionScreenState createState() =>
      _RandomDailyQuestionScreenState();
}

class _RandomDailyQuestionScreenState extends State<RandomDailyQuestionScreen> {
  String _question = 'Loading...';
  final TextEditingController _answerController = TextEditingController();
  bool _isAnswerSubmitted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDailyQuestion();
  }

  Future<void> fetchDailyQuestion() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('questions').get();

      List<DocumentSnapshot> questions = snapshot.docs;
      int dayOfYear = DateTime.now().dayOfYear;
      Random random = Random(dayOfYear);
      int randomIndex = random.nextInt(questions.length);
      String question = questions[randomIndex]['question'];

      setState(() {
        _question = question;
        _isAnswerSubmitted = false;
        _answerController.clear();
      });
    } catch (e) {
      setState(() {
        _question = 'Error fetching random question: $e';
      });
    }
  }

  Future<void> _saveAnswer() async {
    if (_answerController.text.isNotEmpty) {
      if (_isAnswerSubmitted) {
        _showAlreadyAnsweredDialog();
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        QuerySnapshot answerSnapshot = await FirebaseFirestore.instance
            .collection('answers')
            .where('timestamp',
                isGreaterThanOrEqualTo:
                    DateTime.now().subtract(const Duration(days: 1)))
            .get();

        if (answerSnapshot.docs.isNotEmpty) {
          setState(() {
            _isAnswerSubmitted = true;
            _isLoading = false;
          });
          _showAlreadyAnsweredDialog();
        } else {
          await FirebaseFirestore.instance.collection('answers').add({
            'question': _question,
            'answer': _answerController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });
          setState(() {
            _isAnswerSubmitted = true;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Your answer has been saved!'),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error saving answer: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _showAlreadyAnsweredDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'You have already answered the question for today.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Reflects your thoughts!",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreviousAnswersScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                _question,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: TextField(
              controller: _answerController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                labelText: 'Your Answer',
                hintText: 'Write your answer here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                filled: true,
                fillColor: Colors.white12,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textInputAction: TextInputAction.done,
              textAlignVertical: TextAlignVertical.top,
            )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: _isAnswerSubmitted || _isLoading ? null : _saveAnswer,
              icon: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                  : const Icon(Icons.arrow_circle_up),
              label: _isLoading
                  ? const Text("Saving...")
                  : const Text("Submit Answer"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size.fromHeight(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
