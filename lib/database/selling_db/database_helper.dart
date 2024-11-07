import 'dart:convert';
import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/conn_string.dart';
import 'package:pharmacy/models/selling.dart';

class SellingDatabaseHelper {
  int num = 10000;
  Random random = Random();
  int randonNum() {
    num = random.nextInt(999999999);
    return num;
  }

  Future<List<Map<String, dynamic>>> getTransactionsToDB() async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return [];
    }
    const sql = 'SELECT * FROM selling';

    try {
      final results = await conn.execute(sql);
      final transactions = results.rows.map((row) => row.assoc()).toList();

      print('Transactions retrieved successfully');
      return transactions;
    } catch (e) {
      print('Error during SELECT operation: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<int?> getLastTransactionIDToDB() async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }

    const sql = '''
    SELECT MAX(TransactionId) FROM selling
  ''';

    try {
      final results = await conn.execute(sql);
      if (results.isNotEmpty) {
        final lastTransID = results.rows.first.assoc()['bill_code'] as int;
        print('Last transaction ID retrieved is $lastTransID');
        return lastTransID;
      } else {
        print('No transactions found.');
        return null;
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return null;
    } finally {
      await conn.close();
    }
  }

  Future<int?> getLastBillCodeToDB() async {
    final conn = await DatabaseHelper.getConnection();
    int? lastBillCode;
    // int? lastTransactionID =
    //     int.tryParse(getLastTransactionIDToDB().toString());
    // int? lastTransactionID = await getLastTransactionIDToDB();
    // print(lastTransactionID);
    if (conn == null) {
      return null;
    }

    const sql = '''
      SELECT bill_code FROM selling
      WHERE TransactionId = (SELECT MAX(TransactionId) FROM selling)
    ''';
    // final sql = '''
    //   SELECT bill_code FROM selling
    //   WHERE TransactionId = $lastTransactionID
    // ''';

    try {
      final results = await conn.execute(sql);
      if (results.isNotEmpty) {
        lastBillCode =
            int.tryParse(results.rows.first.assoc()['bill_code'].toString());
        print('Last bill_code retrieved successfully $lastBillCode');
        Fluttertoast.showToast(
            msg: 'Last bill_code retrieved successfully $lastBillCode');

        return lastBillCode;
      } else {
        print('No transactions found.');
        return null;
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return null;
    } finally {
      await conn.close();
    }
  }

  Future<void> setBillCodeInDB() async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return;
    }
    int newDefaultBillCode = randonNum();
    String alterSql =
        "ALTER TABLE selling ALTER COLUMN bill_code SET DEFAULT $newDefaultBillCode";
    try {
      await conn.execute(alterSql);
      Fluttertoast.showToast(msg: 'Facture validé');
      print(newDefaultBillCode);
    } on Exception catch (e) {
      print('Alter operation failed $e');
    } finally {
      await conn.close();
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionInfoToDbByDate(
      DateTime sellingDate) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return [];
    }
    String formattedDate =
        "${sellingDate.year}-${sellingDate.month.toString().padLeft(2, '0')}-${sellingDate.day.toString().padLeft(2, '0')}";

    String sql = '''
 SELECT 
  products.product_code,
  products.product_name, 
  selling.unit_price, 
  selling.quantity, 
  total_price,
  selling_date, 
  user_id,
  TransactionId 
 FROM selling 
 JOIN products 
 ON selling.product_code = products.product_code 
 WHERE selling_date BETWEEN '$formattedDate 00:00:00' AND '$formattedDate 23:59:59' ORDER BY TransactionId;


''';

    try {
      final results = await conn.execute(sql);
      if (results.rows.isNotEmpty) {
        final transactions = results.rows.map((row) => row.assoc()).toList();
        print('Transactions info retrieved successfully');
        Fluttertoast.showToast(msg: 'Transactions info retrieved successfully');
        //  print(transactions);
        return transactions;
      } else {
        print("No transaction found with the date :$sellingDate ");
        Fluttertoast.showToast(
            msg: 'No transaction found with the date :$sellingDate');
        return [];
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionInfoFromDbByBillCode(
      int? billCode) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return [];
    }
    //print('avant $billCode');
    //billCode ??= await getLastBillCodeToDB();

    if (billCode == null) {
      Fluttertoast.showToast(msg: 'Bill code is null');
      return [];
    }
    print('Bill code value $billCode');
    String sql = '''
 SELECT 
  products.product_code,
  products.product_name, 
  selling.unit_price, 
  selling.quantity, 
  total_price,
  selling_date, 
  user_id,
  TransactionId 
 FROM selling 
 JOIN products 
 ON selling.product_code = products.product_code 
 WHERE bill_code=$billCode ORDER BY TransactionId;


''';

    try {
      final results = await conn.execute(sql);
      if (results.rows.isNotEmpty) {
        final transactions = results.rows.map((row) => row.assoc()).toList();
        print('Transactions info retrieved successfully');
        Fluttertoast.showToast(msg: 'Transactions info retrieved successfully');
        print(transactions);
        return transactions;
      } else {
        print("No transaction found with the bill code :$billCode DB side");
        Fluttertoast.showToast(
            msg: 'No transaction found with bill code :$billCode');
        return [];
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<void> addTransactionToDB(Selling selling) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      Fluttertoast.showToast(msg: 'Tes données contiennent une erreur');
      return;
    }
    final sql = '''
    INSERT INTO selling (product_code,unit_price,quantity,total_price,user_id,client_id)
    VALUES (
      '${selling.productCode}', 
      '${selling.unitPrice}', 
      '${selling.quantity}', 
      '${selling.totalPrice}', 
      '${selling.userId}',
      '${selling.clientId}'
    )
  ''';

    try {
      await conn.execute(sql);
      print('Transaction made successfully');
      Fluttertoast.showToast(msg: 'La transaction a réussi');
    } catch (e) {
      if (e.toString().contains('Few items remain in the stock')) {
        Fluttertoast.showToast(msg: 'Few items remain in the stock');
      } else if (e.toString().contains('The stock is not enough')) {
        Fluttertoast.showToast(msg: 'The stock is not enough');
      } else {
        print('Error during INSERT operation: $e');
        Fluttertoast.showToast(msg: 'Tes données contiennent une erreur');
      }
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>?> updateTransactionInDB(Selling selling) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }
    final sql = '''
  UPDATE selling 
  SET 
    quantity = '${selling.quantity}'
    
  WHERE 
    TransactionId = '${selling.transactionId}'
  ''';
    print(jsonEncode(sql));
    try {
      final results = await conn.execute(sql);
      if (results.affectedRows.toInt() > 0) {
        print('Transaction updated successfully');
        Fluttertoast.showToast(msg: 'Transaction modifié');
      } else {
        print('No transaction found with the ID :${selling.transactionId}');
        Fluttertoast.showToast(
            msg: 'No transaction found with the ID :${selling.transactionId}');
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

  Future<bool> deleteTransactionToDB(int transactionId) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return false;
    }
    const sql = 'DELETE FROM selling WHERE TransactionId= :transactionId';

    try {
      final results = await conn.execute(sql, {'transactionId': transactionId});
      if (results.rows.isNotEmpty) {
        results.rows.first.assoc();
        print('Transaction deleted successfully');
        Fluttertoast.showToast(msg: 'Transaction supprimée');
        return true;
      } else {
        print('No transaction found with the code :$transactionId');
        Fluttertoast.showToast(
            msg: 'No transaction found with the code :$transactionId');
        return false;
      }
    } catch (e) {
      print('Error during DELETE operation: $e');
      return false;
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>?> getTransactionInfoFromDbByTransactionId(
      int? transactionId) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }
    //print('avant $billCode');
    //billCode ??= await getLastBillCodeToDB();

    if (transactionId == null) {
      Fluttertoast.showToast(msg: 'Transaction Id is null');
      return null;
    }
    print('Transaction Id value $transactionId');
    String sql = '''
 SELECT 
  products.product_code,
  products.product_name, 
  selling.unit_price, 
  selling.quantity, 
  total_price,
  selling_date, 
  user_id
 FROM selling 
 JOIN products 
 ON selling.product_code = products.product_code 
 WHERE TransactionId=$transactionId;


''';

    try {
      final results = await conn.execute(sql);
      if (results.rows.isNotEmpty) {
        final selling = results.rows.first.assoc();
        print('Transaction info retrieved successfully');
        //Fluttertoast.showToast(msg: 'Transaction info retrieved successfully');
        return selling;
      } else {
        print('No Transaction found with the TransactionId :$transactionId');
        Fluttertoast.showToast(
            msg: 'No Transaction found with the code :$transactionId');
        return null;
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return null;
    } finally {
      await conn.close();
    }
  }
}
