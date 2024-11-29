import 'dart:ui';

import 'package:flutter/material.dart';

import 'detail_screen.dart';

Widget buildGlassCard (
BuildContext context,
String docId,
String title,
String duration,
String imagePath){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(
          documentId: docId,
          title: title,
          duration: duration,
          imagePath: imagePath,
        )
          ),
        );
      },

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.3),
                          Colors.blue.withOpacity(0.3)
                        ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3))

                )
              ),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05)
                    ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                )
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      imagePath,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        duration,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

