import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/selling_point_controller.dart';
import 'package:pharmacy/models/selling_points.dart';
import 'package:pharmacy/views/selling_points/create.dart';
import 'package:pharmacy/views/selling_points/update.dart';

class SellingPointsList extends StatefulWidget {
  const SellingPointsList({super.key});

  @override
  State<SellingPointsList> createState() => _SellingPointsListState();
}

class _SellingPointsListState extends State<SellingPointsList> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSellingPts();
  }

  void _fetchSellingPts() async {
    await SellingPointController().getSellingPoints(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 237, 237),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 238, 237, 237),
          title: const Text(
            'YEREMIYA PHARMACY',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
                child: Center(
              child: Opacity(
                opacity: 0.3,
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Liste des succursales',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 73, 71, 71)),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateSellingPoint()));
                                  },
                                  child: const Text('Ajouter une succursale')),
                            ]),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: isLoading
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Colors.blue, strokeWidth: 5.0),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              SellingPointController.sellingPointsList.length,
                          itemBuilder: (context, index) {
                            SellingPoint sellingPoint =
                                SellingPointController.sellingPointsList[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        int? id;
                                        id = sellingPoint.id;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateSellingPoint(
                                                      id: id!,
                                                    )));
                                      },
                                      child: Container(
                                        height: 125,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sellingPoint.name!,
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                sellingPoint.id.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            );
                          }),
                ),
              ],
            ),
          ],
        ));
  }
}
