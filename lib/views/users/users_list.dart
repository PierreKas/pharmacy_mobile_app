import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/users_controller.dart';
import 'package:pharmacy/models/users.dart';
import 'package:pharmacy/views/users/create_user.dart';
import 'package:pharmacy/views/users/update_user.dart';
import 'package:pharmacy/views/users/users_management.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isLoading = true;
  List<User> users = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    await UsersController().getUsers2((List<User> fetchedUsers) {
      setState(() {
        users = fetchedUsers;
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
                      'Liste des utilisateurs',
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
                                                const UsersManagement()));
                                  },
                                  child: const Text('Gérer les utilisateurs')),
                              PopupMenuItem(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateUser()));
                                  },
                                  child: const Text('Ajouter un utilisateur')),
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
                          itemCount: UsersController.usersList.length,
                          itemBuilder: (context, index) {
                            User user = UsersController.usersList[index];
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
                                        int? userId;
                                        userId = user.userId;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateUser(
                                                      userId: userId!,
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
                                                user.fullName,
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                user.phoneNumber,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                user.role!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                user.sellingPointName!,
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
