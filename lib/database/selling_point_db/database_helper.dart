import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/conn_string.dart';
import 'package:pharmacy/models/selling_points.dart';

class SellingPointDatabaseHelper {
  Future<List<Map<String, dynamic>>> getSellingPointsToDB() async {
    final conn = await DatabaseHelper.getConnection();
    const sql = 'SELECT * FROM selling_points';
    if (conn == null) {
      return [];
    }
    try {
      final results = await conn.execute(sql);
      final products = results.rows.map((row) => row.assoc()).toList();

      print('selling points retrived successfully');

      return products;
    } catch (e) {
      print('Error during SELECT operation: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>?> getSellingPointInfoToDB(int id) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }
    const sql = 'SELECT * FROM selling_points WHERE id= :id';

    try {
      final results = await conn.execute(sql, {'id': id});
      if (results.rows.isNotEmpty) {
        final product = results.rows.first.assoc();
        print('Selling point info retrieved successfully');
        return product;
      } else {
        return null;
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return null;
    } finally {
      await conn.close();
    }
  }

  Future<bool> deleteSellingPointToDB(int id) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return false;
    }
    const sql = 'DELETE FROM selling_points WHERE id= :id';

    try {
      final results = await conn.execute(sql, {'id': id});
      if (results.rows.isNotEmpty) {
        results.rows.first.assoc();
        print('Selling point deleted successfully');
        return true;
      } else {
        print('No selling point found with the code :$id');

        return false;
      }
    } catch (e) {
      print('Error during DELETE operation: $e');
      return false;
    } finally {
      await conn.close();
    }
  }

  Future<void> addSellingPointToDB(SellingPoint sellingPoint) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return;
    }
    final sql = '''
    INSERT INTO selling_points (name) 
    VALUES (
      '${sellingPoint.name}'
    )
  ''';

    try {
      await conn.execute(sql);
      print('Selling point added successfully');
      Fluttertoast.showToast(msg: 'succursale ajoutée');
    } catch (e) {
      print('Error during INSERT operation: $e');
      Fluttertoast.showToast(msg: 'Tes données contiennent une erreur');
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>?> updateSellingPointInDB(
      SellingPoint sellingPoint) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }
    final sql = '''
  UPDATE selling_points 
  SET 
    name = '${sellingPoint.name}', 
  WHERE 
    id = '${sellingPoint.id}'
  ''';
    try {
      final results = await conn.execute(sql);
      if (results.affectedRows.toInt() > 0) {
        print('selling point info updated successfully');
        Fluttertoast.showToast(msg: 'Données modifiées');
      } else {
        print('No selling point found with the code :${sellingPoint.id}');
        Fluttertoast.showToast(msg: 'Cette succursale n\'a pas été trouvé');
        return null;
      }
    } catch (e) {
      print('Error during UPDATE operation: $e');
      return null;
    } finally {
      await conn.close();
    }
    return null;
  }
}
