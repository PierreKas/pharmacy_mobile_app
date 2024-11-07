import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/conn_string.dart';
import 'package:pharmacy/models/client.dart';

class ClientsDatabaseHelper {
  Future<List<Map<String, dynamic>>> getClientsToDB() async {
    final conn = await DatabaseHelper.getConnection();
    const sql = 'SELECT * FROM clients';
    if (conn == null) {
      return [];
    }
    try {
      final results = await conn.execute(sql);
      final clients = results.rows.map((row) => row.assoc()).toList();

      print('Clients list retrieved successfully');
      return clients;
    } catch (e) {
      print('Error during SELECT operation: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<void> addClientToDB(Client client) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return;
    }

    final sql = '''
    INSERT INTO clients (phone_number,Full_name, pwd,address)
    VALUES (
      '${client.phoneNumber}',
      '${client.fullName}',
      '${client.password}',
      '${client.address}'
    )
  ''';

    try {
      await conn.execute(sql);
      print('Client added successfully');
      Fluttertoast.showToast(msg: 'Client ajouté');
    } catch (e) {
      print('Error during INSERT operation: $e');
      Fluttertoast.showToast(msg: 'Une erreur s\'est produite');
    } finally {
      await conn.close();
    }
  }
}
