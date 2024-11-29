import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/build_glass.dart';
import 'package:intl/intl.dart';
import 'explore_screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  PlanScreenState createState() => PlanScreenState();
}

class PlanScreenState extends State<PlanScreen> {
  int selectDay = DateTime.now().day;
  final List<String> daysOfWeek = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];
  List<DateTime> dates = [];
  List<Map<String, dynamic>> exerciseCategories = [];
  String userName = "";
  int currentIndex = 0; // Track the selected tab index

  @override
  void initState() {
    super.initState();
    _populateDates();
    _fetchExercise();
    _fetchUserName();
  }

  void _populateDates() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));
    dates = List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index));
    });
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        String email = user.email!;
        userName = email.split('@')[0];
        userName = userName[0].toUpperCase() + userName.substring(1);
      } else {
        userName = "User";
      }

      setState(() {});
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  Future<void> _fetchExercise() async {
    try {
      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('category').get();
      final categories = snapshot.docs
          .map((doc) => {
        'id': doc.id,
        'title': doc['title'] ?? 'Exercise',
        'duration': doc['Duration'] ?? 'Duration not specified',
        'image': doc['Image'] ?? ''
      })
          .toList();
      setState(() {
        exerciseCategories = categories;
      });
    } catch (e) {
      print("Error fetching exercise: $e");
    }
  }

  void _onTabTapped(int index) {
    if (index == 0) {
      setState(() {
        currentIndex = index;
      });
      return; // Exit early without navigating for the "Today" tab
    }

    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 1:
      // Navigate to Therapy Screen
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RandomDailyQuestionScreen(),
          ),
        );*/
        break;
      case 2:
      // Navigate to Explore Screen
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExploreScreen(),
          ),
        );*/
        break;
      case 3:
      // Navigate to Profile Screen
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );*/
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Today's Plan", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0,
                      strokeWidth: 8,
                      color: Colors.deepPurple,
                      backgroundColor: Colors.white24,
                    ),
                    Text("0%", style: TextStyle(color: Colors.white))
                  ],
                ),
                Text(
                  "Enjoy your day, $userName",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.deepPurple,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(dates.length, (index) {
                return Column(
                  children: [
                    Text(
                      DateFormat('d').format(dates[index]),
                      style: TextStyle(
                        fontSize: 24,
                        color: selectDay == dates[index].day
                            ? Colors.deepPurple
                            : Colors.white70,
                        fontWeight: selectDay == dates[index].day
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      daysOfWeek[index],
                      style: const TextStyle(color: Colors.white54),
                    )
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: exerciseCategories.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: exerciseCategories.length,
                itemBuilder: (context, index) {
                  final category = exerciseCategories[index];
                  return buildGlassCard(
                    context,
                    category['id'],
                    category['title'] ?? 'Exercise',
                    category['duration'] ?? 'Duration not specified',
                    category['image'] ?? '',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF1A1A2E),
        unselectedItemColor: const Color(0xFF5E5E65),
        onTap: _onTabTapped, // Handle tab selection
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement), label: 'Therapy'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
