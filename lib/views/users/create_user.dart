import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/controllers/selling_point_controller.dart';
import 'package:pharmacy/controllers/users_controller.dart';
import 'package:pharmacy/models/selling_points.dart';
import 'package:pharmacy/models/users.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController _fullName = TextEditingController();

  final TextEditingController _phoneNumber = TextEditingController();

  final TextEditingController _role = TextEditingController();

  final TextEditingController _sellingPoint = TextEditingController();

  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  String? selectedRole;
  List<SellingPoint> sellingPoints = [];
  SellingPoint? selectedSellingPt;
  int? selectedSellingPtId;
  @override
  void initState() {
    _fetchSellingPts();

    super.initState();
  }

  void _fetchSellingPts() async {
    await SellingPointController()
        .getSellingPoints2((List<SellingPoint> fetchedSellingPts) {
      setState(() {
        sellingPoints = fetchedSellingPts;
      });
    });
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
                      'Complétez ici les données du nouveau utilisateur',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 240.0),
                      child: Text(
                        'Téléphone',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_android_rounded,
                          color: Colors.blue,
                        ),
                        //floatingLabelBehavior: FloatingLabelBehavior.never
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 220.0),
                      child: Text(
                        'Mot de passe',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _password,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        //labelText: 'Mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          borderSide: const BorderSide(color: Colors.blue),
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
                    const Padding(
                      padding: EdgeInsets.only(right: 260.0),
                      child: Text(
                        'Noms',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _fullName,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        //labelText: 'Noms',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.person, // Adjust icon as needed
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 200.0),
                      child: Text(
                        'Point de vente',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _fetchSellingPts();
                      },
                      child: DropdownButtonFormField<int>(
                        value: selectedSellingPtId,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            )),
                        items: sellingPoints.isEmpty
                            ? []
                            : sellingPoints.map((SellingPoint sellingPt) {
                                return DropdownMenuItem<int>(
                                  value: sellingPt.id,
                                  child: Text(sellingPt.name!),
                                );
                              }).toList(),
                        onChanged: (int? newSellingPtId) {
                          setState(() {
                            selectedSellingPtId = newSellingPtId;
                            selectedSellingPt = sellingPoints.firstWhere(
                                (sellingPt) => sellingPt.id == newSellingPtId);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 260.0),
                      child: Text(
                        'Role',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(80.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.circle_outlined,
                            color: Colors.blue,
                          )),
                      items: const [
                        DropdownMenuItem(
                          value: 'MANAGER',
                          child: Text('MANAGER'),
                        ),
                        DropdownMenuItem(
                          value: 'SELLER',
                          child: Text('REVENDEUR'),
                        ),
                      ],
                      onChanged: (String? role) {
                        setState(() {
                          selectedRole = role;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String phoneNumber = _phoneNumber.text;
                        String password = _password.text;
                        String fullName = _fullName.text;
                        String sellingPointId = _sellingPoint.text;
                        String role = _role.text;
                        //String userState = 'DENIED';

                        User newUser = User(
                          fullName: fullName,
                          phoneNumber: phoneNumber,
                          password: password,
                          sellingPointId: int.tryParse(sellingPointId),
                          role: role,
                          //  userState: userState
                        );
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        UsersController().addUser(newUser, () {
                          print(newUser.sellingPointId);
                        });
                        _fullName.clear();
                        _password.clear();
                        _phoneNumber.clear();
                        _role.clear();
                        _sellingPoint.clear();
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
