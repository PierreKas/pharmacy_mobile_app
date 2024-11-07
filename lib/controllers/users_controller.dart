import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/users_db/database_helper.dart';
import 'package:pharmacy/models/users.dart';
import 'package:pharmacy/pages/home.dart';

class UsersController {
  static List<User> usersList = [];
  static String userRole = '';
  String userStatus = '';
  static int userId = 0;

  Future<void> addUser(User user, Function callback) async {
    if (user.fullName.isEmpty) {
      Fluttertoast.showToast(msg: 'Complète le nom de l\'utilisateur');
      return;
    }

    if (user.phoneNumber.isEmpty) {
      Fluttertoast.showToast(msg: 'Complète le numéro de l\'utilisateur');
      return;
    }

    if (user.fullName.isEmpty) {
      Fluttertoast.showToast(msg: 'Complète le nom de l\'utilisateur');
      return;
    }
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      await dbHelper.addUserToDB(user);
      usersList.add(user);
      callback();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de l\'ajout de l\'utilisateur');
    }
  }

  Future<void> getUsers(Function callback) async {
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      List<Map<String, dynamic>> usersData = await dbHelper.getUsersToDB();

      // usersList.clear();
      print(usersData);

      usersList = usersData.map((userData) {
        return User(
            fullName: userData['Full_name'],
            sellingPointName: userData['name'],
            phoneNumber: userData['phone_number'],
            role: userData['role'],
            sellingPointId: (userData['selling_point_id'] is int)
                ? userData['selling_point_id'] as int
                : int.tryParse(userData['selling_point_id'] as String),
            password: userData['pwd'],
            userState: userData['user_state'],
            // userId: userData['user_id'],
            userId: (userData['user_id'] is int)
                ? userData['user_id'] as int
                : int.tryParse(userData['user_id'] as String)

            /**
       *  quantity: (productData['quantity'] is int)
              ? productData['quantity'] as int
              : int.tryParse(productData['quantity'] as String) ?? 0,
       */
            );
      }).toList();

      callback();
      //Fluttertoast.showToast(msg: 'Utilisateurs récupérés avec succès');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des utilisateurs');
      print(e);
    }
  }

  Future<void> getUsers2(Function(List<User>) callback) async {
<<<<<<< HEAD
=======
    // try {
    //   UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
    //   List<Map<String, dynamic>> usersData = await dbHelper.getUsersToDB();

    //   // usersList.clear();
    //   print(usersData);

    //   usersList = usersData.map((userData) {
    //     int? userId;
    //     if (userData['user_id'] != null) {
    //       if (userData['user_id'] is int) {
    //         userId = userData['user_id'];
    //       } else if (userData['user_id'] is String) {
    //         userId = int.tryParse(userData['user_id']);
    //       }
    //     }
    //     print(userData);
    //     return User(
    //       fullName: userData['Full_name'],
    //       sellingPointName: userData['name'],
    //       phoneNumber: userData['phone_number'],
    //       role: userData['role'],
    //       sellingPointId: (userData['selling_point_id'] is int)
    //           ? userData['selling_point_id'] as int
    //           : int.tryParse(userData['selling_point_id'] as String),
    //       password: userData['pwd'],
    //       userState: userData['user_state'],
    //       userId: userId,
    //     );
    //   }).toList();

    //   callback(usersList);
    //   //Fluttertoast.showToast(msg: 'Utilisateurs récupérés avec succès');
    // } catch (e) {
    //   Fluttertoast.showToast(
    //       msg: 'Erreur lors de la récupération des utilisateurs');
    //   print(e);
    // }
>>>>>>> temp-branch
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      List<Map<String, dynamic>> usersData = await dbHelper.getUsersToDB();

<<<<<<< HEAD
      // usersList.clear();
      print(usersData);

      usersList = usersData.map((userData) {
        return User(
            fullName: userData['Full_name'],
            sellingPointName: userData['name'],
            phoneNumber: userData['phone_number'],
            role: userData['role'],
            sellingPointId: (userData['selling_point_id'] is int)
                ? userData['selling_point_id'] as int
                : int.tryParse(userData['selling_point_id'] as String),
            password: userData['pwd'],
            userState: userData['user_state'],
            userId: (userData['user_id'] is int)
                ? userData['user_id'] as int
                : int.tryParse(userData['user_id'] as String));
      }).toList();

      callback(usersList);
      //Fluttertoast.showToast(msg: 'Utilisateurs récupérés avec succès');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des utilisateurs');
      print(e);
=======
      print('Raw users data: $usersData'); // For debugging

      usersList = usersData.map((userData) {
        return User.fromJson(userData); // Use the fromJson factory constructor
      }).toList();

      print('Processed users list: $usersList'); // For debugging

      callback(usersList);
    } catch (e) {
      print('Error in getUsers2: $e'); // Detailed error logging
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des utilisateurs');
    }
  }

  Future<void> getUsers3(Function(List<User>) callback) async {
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      List<Map<String, dynamic>> usersData = await dbHelper.getUsersToDB();

      print('Raw users data: $usersData'); // For debugging

      usersList = usersData.map((userData) {
        return User.fromJson(userData); // Use the fromJson factory constructor
      }).toList();

      print('Processed users list: $usersList'); // For debugging

      callback(usersList);
    } catch (e) {
      print('Error in getUsers3: $e'); // Detailed error logging
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des utilisateurs');
>>>>>>> temp-branch
    }
  }

  Future<void> login(
      String phoneNumber, String password, BuildContext context) async {
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      Map<String, dynamic>? userData =
          await dbHelper.getAuthenticationData(phoneNumber, password);

      // usersList.clear();
      print('Raw product data: $userData');

      if (userData != null) {
        print('Utilisateur trouvé');
        userRole = userData['role'];
        userStatus = userData['user_state'];
        //  userId = userData['user_id'];
        userId = ((userData['user_id'] is int)
            ? userData['user_id'] as int
            : int.tryParse(userData['user_id'] as String))!;
        /**
         * userId: (userData['user_id'] is int)
                ? userData['user_id'] as int
                : int.tryParse(userData['user_id'] as String)
         */
        if (userStatus.toLowerCase() == 'approved') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Home();
          }));
        } else {
          print(userStatus);
          Fluttertoast.showToast(msg: userStatus);
          Fluttertoast.showToast(
              msg: 'Tu n\'es pas autorisé d\'acceder au system',
              textColor: Colors.white,
              backgroundColor: Colors.blue);
        }
      } else {
        Fluttertoast.showToast(msg: 'Cet utilisateur n\'a pas été touvé');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des données de l\'utilisateur');
    }
  }

  Future<void> getUserInfo(int userId, Function callback) async {
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      Map<String, dynamic>? userData = await dbHelper.getUserInfoToDB(userId);

      // usersList.clear();
      print('Raw product data: $userData');

      if (userData != null) {
        User user = User(
            fullName: userData['Full_name'] as String,
            sellingPointName: userData['name'],
            phoneNumber: userData['phone_number'] as String,
            sellingPointId: (userData['selling_point_id'] is int)
                ? userData['selling_point_id'] as int
                : int.tryParse(userData['selling_point_id'] as String),
            password: (userData['pwd'] as String),
            role: userData['role'] as String,
            userState: userData['user_state'] as String,
            userId: (userData['user_id'] is int)
                ? userData['user_id'] as int
                : int.tryParse(userData['user_id'] as String));
        callback(user);
      } else {
        Fluttertoast.showToast(
            msg: 'No product found with the code: US$userId');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des données de l\'utilisateur');
    }
  }

  Future<void> updateUserInfo(User user, Function callback) async {
<<<<<<< HEAD
    if (user.password.isEmpty || user.fullName.isEmpty) {
=======
    if (user.password!.isEmpty || user.fullName.isEmpty) {
>>>>>>> temp-branch
      Fluttertoast.showToast(msg: 'Veuillez remplir tous les champs requis');
      return;
    }
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      await dbHelper.updateUserInfoInTheDB(user);
      int index =
          usersList.indexWhere((p) => p.phoneNumber == user.phoneNumber);
      if (index != -1) {
        usersList[index] = user;
      }
      callback();
      await getUsers(callback);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Erreur lors de la mise à jour des données de l\'utilisateur');
    }
  }

  Future<void> updateUserStatus(
      int userId, String userState, Function callback) async {
    try {
      UsersDatabaseHelper dbHelper = UsersDatabaseHelper();
      await dbHelper.updateUserStatusInTheDB(userId, userState);
      int index = usersList.indexWhere((p) => p.userId == userId);
      if (index != -1) {
        usersList[index].userState = userState;
      }
      callback();
      await getUsers2((List<User> users) {
        usersList = users;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors du changement du statut');
    }
  }
}
