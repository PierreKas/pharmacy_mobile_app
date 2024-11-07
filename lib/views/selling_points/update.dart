import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/selling_point_controller.dart';
import 'package:pharmacy/models/selling_points.dart';
import 'package:pharmacy/views/selling_points/displayList.dart';

class UpdateSellingPoint extends StatefulWidget {
  final int id;
  const UpdateSellingPoint({super.key, required this.id});

  @override
  State<UpdateSellingPoint> createState() => _UpdateSellingPointState();
}

class _UpdateSellingPointState extends State<UpdateSellingPoint> {
  final TextEditingController _name = TextEditingController();
  TextEditingController _id = TextEditingController();
  //final TextEditingController _role = TextEditingController();

  bool isSellingPointUpdated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _id = TextEditingController(text: widget.id.toString());
    _fetchSellingPtData();
  }

  void _fetchSellingPtData() async {
    try {
      await SellingPointController().getSellingPointInfo(widget.id,
          (SellingPoint sellingPoint) {
        setState(() {
          _name.text = sellingPoint.name!;
        });
      });
      isSellingPointUpdated = true;
    } on Exception catch (e) {
      isSellingPointUpdated = false;
      print(e);
    }
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
                      'Modifiez les informations dde la succursale',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 240.0),
                      child: Text(
                        'User ID',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _id,
                      cursorColor: Colors.grey,
                      enabled: false,
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
                          Icons.verified_user_rounded,
                          color: Colors.blue,
                        ),
                        //floatingLabelBehavior: FloatingLabelBehavior.never
                      ),
                    ),
                    const SizedBox(
                      height: 16,
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
                          Icons.circle_outlined, // Adjust icon as needed
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

                        String id = _id.text;

                        SellingPoint updatedSellingPt = SellingPoint(
                          name: name,
                          id: int.tryParse(id),
                        );

                        SellingPointController()
                            .updateSellingPoint(updatedSellingPt, () {});
                        _name.clear();
                        _id.clear();

                        if (isSellingPointUpdated == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SellingPointsList()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        'Modifier',
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
