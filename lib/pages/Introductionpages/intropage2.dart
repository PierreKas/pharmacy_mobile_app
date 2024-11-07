import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 66, 117),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
        child: Column(
          children: [
            Image.asset(
              'assets/online-pharma.webp',
              width: 300,
              height: 200,
            ),
            const Text(
              'Tu peux maintenant gérer tes achats et tes ventes en ligne',
              style: TextStyle(fontSize: 12, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
