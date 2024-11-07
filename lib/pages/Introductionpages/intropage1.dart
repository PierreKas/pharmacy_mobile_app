import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
        child: Column(
          children: [
            Image.asset(
              'assets/pharma.jpg',
              width: 300,
              height: 200,
            ),
            const Text(
              'Gère ta pharmacie via ton téléphone',
              style: TextStyle(fontSize: 12, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
