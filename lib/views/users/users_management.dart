import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/users_controller.dart';
import 'package:pharmacy/models/users.dart';

class UsersManagement extends StatefulWidget {
  const UsersManagement({super.key});

  @override
  State<UsersManagement> createState() => _UsersManagementState();
}

class _UsersManagementState extends State<UsersManagement> {
  bool isLoading = true;
  bool isLoadingBtnDeny = false;
  bool isLoadingBtnApprove = false;
  List<User> _usersDetails = [];
  @override
  void initState() {
    // TODO: implement initState
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    try {
      await UsersController().getUsers2((List<User> usersDetails) {
        setState(() {
          _usersDetails = usersDetails;
          isLoading = false;
          print(usersDetails);
        });
      });
    } on Exception catch (e) {
      print('UI shows $e');
    }
  }

  void _updateUserState(int userId, String? userState) async {
    await UsersController().updateUserStatus(userId, userState ?? '', () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'GESTION DES UTILISATEURS',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          GestureDetector(
                              onTap: () {
                                _fetchUsers();
                              },
                              child: const Icon(Icons.refresh))
                        ],
                      ),
                    ),
                    //  const Text('Facture N*}'),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.blue,
                                                        strokeWidth: 5.0),
                                              )
                                            : DataTable(columns: const [
                                                DataColumn(
                                                    label: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Téléphone',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Role',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Point de vente',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'User State',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  'Actions',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ))
                                              ], rows: [
                                                ...List.generate(
                                                    _usersDetails.length,
                                                    (index) {
                                                  User user =
                                                      _usersDetails[index];
                                                  return DataRow(cells: [
                                                    DataCell(
                                                        Text(user.fullName)),
                                                    DataCell(
                                                        Text(user.phoneNumber)),
                                                    DataCell(
                                                        Text(user.role ?? '')),
                                                    DataCell(Text(user
                                                        .sellingPointName!)),
                                                    DataCell(Text(
                                                        user.userState ?? '')),
                                                    DataCell(Row(
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .red),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  isLoadingBtnDeny =
                                                                      true;
                                                                });
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            5),
                                                                    () {
                                                                  setState(() {
                                                                    isLoadingBtnDeny =
                                                                        false;
                                                                  });
                                                                });
                                                                _updateUserState(
                                                                    user.userId!,
                                                                    'DENIED');
                                                              },
                                                              child: isLoadingBtnDeny
                                                                  ? const SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .white,
                                                                        strokeWidth:
                                                                            2,
                                                                      ),
                                                                    )
                                                                  : const Text(
                                                                      'Deny',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                        ),
                                                        // const SizedBox(
                                                        //   width: 5,
                                                        // ),
                                                        Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .green),
                                                          child: TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  isLoadingBtnApprove =
                                                                      true;
                                                                });
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            5),
                                                                    () {
                                                                  setState(() {
                                                                    isLoadingBtnApprove =
                                                                        false;
                                                                  });
                                                                });
                                                                _updateUserState(
                                                                    user.userId!,
                                                                    'APPROVED');
                                                              },
                                                              child: isLoadingBtnApprove
                                                                  ? const SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .white,
                                                                        strokeWidth:
                                                                            2,
                                                                      ),
                                                                    )
                                                                  : const Text(
                                                                      'Approve',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                        ),
                                                      ],
                                                    ))
                                                  ]);
                                                })
                                              ]),
                                      ],
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
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
        ],
      ),
    );
  }
}
