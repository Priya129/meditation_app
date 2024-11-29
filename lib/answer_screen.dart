import 'package:flutter/material.dart';

class AnswerDetailScreen extends StatelessWidget {
  final String question;
  final String answer;

  const AnswerDetailScreen({
    super.key,
    required this.question,
    required this.answer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("Your thought",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                answer,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),

              )
            ],

      )
      )
    );
  }

}