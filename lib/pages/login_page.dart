import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/users_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumber = TextEditingController();

  final TextEditingController _password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(70),
                  child: Image.asset(
                    'assets/logo-no-background.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Container(
                width: 280,
                height: MediaQuery.of(context).size.height - 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          const Text(
                            'SIGN IN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromARGB(255, 73, 71, 71)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 200.0),
                            child: Text(
                              'Tél',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            controller: _phoneNumber,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              // labelText: 'Tél',
                              // labelStyle: const TextStyle(
                              //   color: Color.fromARGB(255, 177, 223, 179),
                              // ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: const Icon(
                                Icons.phone_android_rounded,
                                color: Colors.blue,
                              ),
                              //floatingLabelBehavior: FloatingLabelBehavior.never
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 165.0),
                            child: Text(
                              'Password',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            controller: _password,
                            cursorColor: Colors.grey,
                            obscureText: true,
                            decoration: InputDecoration(
                              //labelText: 'Mot de passe',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              Future.delayed(const Duration(seconds: 5), () {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                              UsersController().login(
                                  _phoneNumber.text, _password.text, context);
                              _password.clear();
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
                                    'SIGN IN',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 238, 237, 237),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
