import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class DatabaseHelper {
  // Database connection details
  ///==========When my PC is the server===============\\\
  // static String host = '192.168.2.19';///This can change
  // static int port = 3306;
  // static String username = 'root';
  // static String password = 'KASANANI';
  // static String databaseName = 'pharmacy_management_system_db';

  ///==========sql5.freesqldatabase.com'===============\\\
  // static String host = 'sql5.freesqldatabase.com';
  // static int port = 3306;
  // static String username = 'sql5730314';
  // static String password = 'PYW4dalp7b';
  // static String databaseName = 'sql5730314';

  ///==========sAlways data'===============\\\
  static String host = 'mysql-pierrekasanani.alwaysdata.net';
  static int port = 3306;
  static String username = '375592';
  static String password = 'Kasa2002@';
  static String databaseName = 'pierrekasanani_pharmacy_management_system_db';
  /**
   * =  Host: sql5.freesqldatabase.com
=  Database name: sql5730314
=  Database user: sql5730314
=  Database password: PYW4dalp7b
=  Port number: 3306
   */
  static MySQLConnection? conn;
  // Get a connection
  static Future<MySQLConnection?> getConnection() async {
    try {
      if (conn != null && conn?.connected == true) return conn!;
      conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: username,
        password: password,
        databaseName: databaseName,
        secure: true,
      );

      await conn!.connect();
      print('DB connected successfully');
      // var uri = Uri.parse('http://$host');
      // var response = await http.get(uri);
      // print(response.body);
      //print(conn);
      return conn!;
    } on Exception catch (e) {
      print(e.toString());
      if (e.toString().contains('No address associated with hostname')) {
        Fluttertoast.showToast(
            msg:
                'Vérifiez votre connexion internet, le serveur n\'a pas été retrouvé',
            backgroundColor: Colors.red);
      }
      return null;
    }
  }

  static Future<void> closeConnection() async {
    if (conn != null && conn!.connected) {
      try {
        await conn!.close();
        print('DB connection closed successfully');
      } catch (e) {
        print('Error closing DB connection: $e');
      }
    } else {
      print('Connection is not established or already closed.');
    }
  }
}
