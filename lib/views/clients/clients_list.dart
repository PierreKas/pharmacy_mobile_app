import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/clients_controller.dart';
import 'package:pharmacy/models/client.dart';
import 'package:pharmacy/views/clients/create_client.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({super.key});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchClients();
  }

  void _fetchClients() async {
    await ClientsController().getClients(() {
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
                      'Liste des clients',
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
                                                const CreateClient()));
                                  },
                                  child: const Text('Ajouter un client')),
                              PopupMenuItem(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const CreateUser()));
                                  },
                                  child: const Text('')),
                            ]),
                    // GestureDetector(
                    //   onTap: () {
                    //     _fetchClients();
                    //   },
                    //   child: const Icon(Icons.refresh),
                    // )
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
                          itemCount: ClientsController.clientsList.length,
                          itemBuilder: (context, index) {
                            Client client =
                                ClientsController.clientsList[index];
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
                                        // int? userId;
                                        // userId = user.userId;
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             UpdateUser(
                                        //               userId: userId!,
                                        //             )));
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
                                                client.fullName,
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                client.phoneNumber,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              Text(
                                                client.address!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
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
