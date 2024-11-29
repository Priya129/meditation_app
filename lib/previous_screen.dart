import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'answer_screen.dart';

class PreviousAnswersScreen extends StatelessWidget {
  const PreviousAnswersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> gridColors = [
      Colors.deepPurpleAccent,
      Colors.purple,
      Colors.pink,
      Colors.indigoAccent,
      Colors.teal,
      Colors.orangeAccent
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("Your Daily Questions",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('answers').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error loading answer",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No answers found",
                    style: TextStyle(color: Colors.white)),
              );
            }
            final answers = snapshot.data!.docs;
            return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9),
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answerData = answers[index];
                  final question = answerData['question'] ?? 'No question';
                  final answer = answerData['answer'] ?? 'No answer';
                  final answerId = answerData.id;

                  return GestureDetector(
                    onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswerDetailScreen(
                            question: question, answer: answer)
                      )
                    );
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Container(
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.deepPurple,
                                            Colors.purpleAccent,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  padding: const EdgeInsets.all(16),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Are you sure you want to delete this answer?",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('answers')
                                          .doc(answerId)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Delete",
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
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: gridColors[index % gridColors.length],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            answer,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
