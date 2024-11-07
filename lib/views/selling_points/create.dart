import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/selling_point_controller.dart';
import 'package:pharmacy/models/selling_points.dart';
import 'package:pharmacy/views/selling_points/displayList.dart';

class CreateSellingPoint extends StatefulWidget {
  const CreateSellingPoint({super.key});

  @override
  State<CreateSellingPoint> createState() => _CreateSellingPointState();
}

class _CreateSellingPointState extends State<CreateSellingPoint> {
  final TextEditingController _name = TextEditingController();

  bool isLoading = false;
  @override
  void dispose() {
    _name.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      body: Stack(
        children: [
          Positioned.fill(
              child: Center(
            child: Opacity(
              opacity: 0.2,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/logo-no-background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const Text(
                      'YEREMIYA PHARMACY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 73, 71, 71)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Complétez ici les données de la nouvelle succursale',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 240.0),
                      child: Text(
                        'Nom',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _name,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: const Icon(
                          Icons.circle_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String name = _name.text;

                        SellingPoint newSellingPoint = SellingPoint(
                          name: name,
                        );
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        SellingPointController()
                            .addSellingPoint(newSellingPoint, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SellingPointsList()));
                        });
                        _name.clear();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Créer',
                              style: TextStyle(
                                color: Color.fromARGB(255, 238, 237, 237),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
