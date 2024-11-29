import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String duration;
  final String imagePath;
  final String documentId;

  const DetailScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.imagePath,
    required this.documentId
});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> instructions = [];
  List<String> benefits = [];

  @override

  void initState() {
    super.initState();
    _fetchInstructions();
    _fetchBenefits();
  }

  Future<void> _fetchInstructions() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('category')
          .doc(widget.documentId)
          .get();

      if(doc.exists) {
        List<dynamic> fetchedInstructions = doc['Instruction'];
        setState(() {
          instructions = fetchedInstructions.cast<String>();
        });
      }
    } catch(e) {
      print("Error fetching instructions: $e");
    }
  }

  Future<void> _fetchBenefits() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('category')
          .doc(widget.documentId)
          .get();

      if(doc.exists) {
        List<dynamic> fetchedBenefits = doc['Benefits'];
        setState(() {
          benefits = fetchedBenefits.cast<String>();
        });
      }
    } catch(e) {
      print("Error fetching benefits: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: Image.network(
                    widget.imagePath,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              const Text(
                'Instructions:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 8,),
              ListView.builder(
                shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: instructions.length,
                  itemBuilder: (context, index){
                  return ListTile(
                    leading: const Text(
                      '•',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    title: Text(
                    instructions[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                  }),
              const SizedBox(height: 10,),
              const Text(
                'Benefits:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 8,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: benefits.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      leading: const Text(
                        '•',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      title: Text(
                        benefits[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}