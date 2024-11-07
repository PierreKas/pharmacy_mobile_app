import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/selling_db/database_helper.dart';
import 'package:pharmacy/models/selling.dart';

class SellsController {
  static List<Selling> transactionsList = [];
  // static int qty = 0;
  // static String prodName = '';
  // static double unitPr = 0.0;
  // static double totPrice = 0.0;
  // static DateTime? ssellingDate = DateTime.now();
  static List<Map<String, dynamic>>? transactionsDataForBill;
  Future<void> addTransaction(Selling transaction, Function callback) async {
    // if (transaction.productCode == null ||
    //     transaction.productCode!.isEmpty ||
    //     transaction.unitPrice == null ||
    //     transaction.unitPrice! <= 0 ||
    //     transaction.quantity == null ||
    //     transaction.quantity! <= 0 ||
    //     transaction.totalPrice == null ||
    //     transaction.totalPrice! <= 0 ||
    //     transaction.userId == 0 ||
    //     transaction.clientId == 0) {
    //   Fluttertoast.showToast(msg: 'Veuillez remplir tous les champs requis');
    //   return;
    // }

    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      await dbHelper.addTransactionToDB(transaction);
      transactionsList.add(transaction);
      callback();
      //getTransactions(callback);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de l\'ajout du produit');
    }
  }
//  Future<void> setBillCode() async {
//     final conn = await DatabaseHelper.getConnection();
//     if (conn == null) {
//       return;
//     }
//     int newDefaultBillCode = randonNum();
//     String alterSql =
//         "ALTER TABLE selling ALTER COLUMN bill_code SET DEFAULT newDefaultBillCode";
//     await conn.execute(alterSql);
//     await conn.close();
//   }

  Future<void> setBillCode() async {
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      await dbHelper.setBillCodeInDB();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Bill code didn\'t');
    }
  }

  // Future<String?> getLastBillCodeToDB() async {
  //   final conn = await DatabaseHelper.getConnection();
  //   if (conn == null) {
  //     return null;
  //   }

  //   const sql = '''
  //   SELECT bill_code FROM selling
  //   WHERE transaction_id = (SELECT MAX(transaction_id) FROM selling)
  // ''';

  //   try {
  //     final results = await conn.execute(sql);
  //     if (results.isNotEmpty) {
  //       final lastBillCode = results.rows.first.assoc()['bill_code'];
  //       print('Last bill_code retrieved successfully $lastBillCode');
  //       return lastBillCode;
  //     } else {
  //       print('No transactions found.');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error during SELECT operation: $e');
  //     return null;
  //   } finally {
  //     await conn.close();
  //   }
  // }

  Future<int?> getLastBillCode() async {
    int? lastBillCode;
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      lastBillCode = await dbHelper.getLastBillCodeToDB();
      print(lastBillCode);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Nothing was returned');
    }
    return lastBillCode;
  }

  Future<void> getSellingInfoByDate(
      DateTime sellingDate, Function(List<Selling>) callback) async {
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      // List<Map<String, dynamic>>? transactionsData =
      //     await dbHelper.getTransactionInfoToDbByDate(
      //         DateTime(sellingDate.year, sellingDate.month, sellingDate.day));
      // DateTime dateTime = DateTime.parse('2024-03-22 10:02:48');
      List<Map<String, dynamic>>? transactionsData =
          await dbHelper.getTransactionInfoToDbByDate(sellingDate);

      // ignore: unnecessary_null_comparison
      if (transactionsData != null && transactionsData.isNotEmpty) {
        List<Selling> transactions = transactionsData.map((transactionData) {
          print('$transactionData');

          return Selling(
            productCode: transactionData['product_code'] as String,
            userId: (transactionData['user_id'] is int)
                ? transactionData['user_id'] as int
                : int.tryParse(transactionData['user_id'] as String),
            unitPrice: (transactionData['unit_price'] is num)
                ? (transactionData['unit_price'] as num).toDouble()
                : double.tryParse(transactionData['unit_price'] as String) ??
                    0.0,
            quantity: (transactionData['quantity'] is int)
                ? transactionData['quantity'] as int
                : int.tryParse(transactionData['quantity'] as String) ?? 0,
            sellingDate: transactionData['selling_date'] != null
                ? DateTime.parse(transactionData['selling_date'] as String)
                : null,
            totalPrice: (transactionData['total_price'] is num)
                ? (transactionData['total_price'] as num).toDouble()
                : double.tryParse(transactionData['total_price'] as String) ??
                    0.0,
            productName: transactionData['product_name'] as String,
          );
        }).toList();

        callback(transactions);
        print("Controller works okay");
      } else {
        Fluttertoast.showToast(
            msg:
                'No transactions found for the date: ${DateTime(sellingDate.year, sellingDate.month, sellingDate.day)}');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des transactions');
    }
  }

  Future<void> getTransactionInfoByBillCode(
      int? billCode, Function(List<Selling>) callback) async {
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      // billCode ??= await dbHelper.getLastBillCodeToDB();
      // print(billCode);
      List<Map<String, dynamic>>? transactionsDataForBill =
          await dbHelper.getTransactionInfoFromDbByBillCode(billCode);
      print(transactionsDataForBill);
      // ignore: unnecessary_null_comparison
      if (transactionsDataForBill != null &&
          transactionsDataForBill.isNotEmpty) {
        List<Selling> transactions =
            transactionsDataForBill.map((transactionData) {
          print('Transac data for this bill code: $transactionData');
          // qty = (transactionData['quantity'] is int)
          //     ? transactionData['quantity'] as int
          //     : int.tryParse(transactionData['quantity'] as String) ?? 0;
          // prodName = transactionData['product_name'] as String;
          // unitPr = (transactionData['unit_price'] is num)
          //     ? (transactionData['unit_price'] as num).toDouble()
          //     : double.tryParse(transactionData['unit_price'] as String) ?? 0.0;
          // totPrice = (transactionData['total_price'] is num)
          //     ? (transactionData['total_price'] as num).toDouble()
          //     : double.tryParse(transactionData['total_price'] as String) ??
          //         0.0;
          // ssellingDate = transactionData['selling_date'] != null
          //     ? DateTime.parse(transactionData['selling_date'] as String)
          //     : null;
          //print('Quantity in controller : $qty');
          return Selling(
            // billCode: (transactionData['bill_code'] is int)
            //     ? transactionData['bill_code'] as int
            //     : int.tryParse(transactionData['bill_code'] as String) ?? 0,
            productCode: transactionData['product_code'] as String,
            userId: (transactionData['user_id'] is int)
                ? transactionData['user_id'] as int
                : int.tryParse(transactionData['user_id'] as String),
            unitPrice: (transactionData['unit_price'] is num)
                ? (transactionData['unit_price'] as num).toDouble()
                : double.tryParse(transactionData['unit_price'] as String) ??
                    0.0,
            quantity: (transactionData['quantity'] is int)
                ? transactionData['quantity'] as int
                : int.tryParse(transactionData['quantity'] as String) ?? 0,
            sellingDate: transactionData['selling_date'] != null
                ? DateTime.parse(transactionData['selling_date'] as String)
                : null,
            totalPrice: (transactionData['total_price'] is num)
                ? (transactionData['total_price'] as num).toDouble()
                : double.tryParse(transactionData['total_price'] as String) ??
                    0.0,
            productName: transactionData['product_name'] as String,
            transactionId: (transactionData['TransactionId'] is int)
                ? transactionData['TransactionId'] as int
                : int.tryParse(transactionData['TransactionId'] as String) ?? 0,
          );
        }).toList();

        callback(transactions);
      } else {
        Fluttertoast.showToast(
            msg: 'No transactions found for the bill code: $billCode');
        print('No transactions found for the bill code: $billCode');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des transactions');
    }
  }

  Future<void> updateTransactionOnBillCode(
      Selling transaction, Function callback) async {
    if (transaction.quantity! <= 0) {
      Fluttertoast.showToast(
          msg: 'Veuillez remplir tous lla quantité souhaitée');
      return;
    }
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      await dbHelper.updateTransactionInDB(transaction);
      int index = transactionsList
          .indexWhere((p) => p.transactionId == transaction.transactionId);
      if (index != -1) {
        transactionsList[index] = transaction;
      }

      callback();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de la mise à jour du produit');
    }
  }

  //   Future<void> updateTransactionOnBillCode(
  //     Selling transaction, Function(List<Selling>) callback) async {
  //   if (transaction.quantity! <= 0) {
  //     Fluttertoast.showToast(
  //         msg: 'Veuillez remplir tous lla quantité souhaitée');
  //     return;
  //   }
  //   try {
  //     SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
  //     await dbHelper.updateTransactionInDB(transaction);
  //     int index = transactionsList
  //         .indexWhere((p) => p.transactionId == transaction.transactionId);
  //     if (index != -1) {
  //       transactionsList[index] = transaction;
  //     }

  //     await getTransactionInfoByBillCode(transaction.billCode,
  //         (updatedTransactions) {
  //       callback(updatedTransactions);
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Erreur lors de la mise à jour du produit');
  //   }
  // }

  Future<void> getTransactionInfoByTransactionId(
      int? transactionId, Function callback) async {
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();

      Map<String, dynamic>? transactionData =
          await dbHelper.getTransactionInfoFromDbByTransactionId(transactionId);

      // ignore: unnecessary_null_comparison
      if (transactionData != null) {
        Selling transaction = Selling(
          productCode: transactionData['product_code'] as String,
          userId: (transactionData['user_id'] is int)
              ? transactionData['user_id'] as int
              : int.tryParse(transactionData['user_id'] as String),
          unitPrice: (transactionData['unit_price'] is num)
              ? (transactionData['unit_price'] as num).toDouble()
              : double.tryParse(transactionData['unit_price'] as String) ?? 0.0,
          quantity: (transactionData['quantity'] is int)
              ? transactionData['quantity'] as int
              : int.tryParse(transactionData['quantity'] as String) ?? 0,
          sellingDate: transactionData['selling_date'] != null
              ? DateTime.parse(transactionData['selling_date'] as String)
              : null,
          totalPrice: (transactionData['total_price'] is num)
              ? (transactionData['total_price'] as num).toDouble()
              : double.tryParse(transactionData['total_price'] as String) ??
                  0.0,
          productName: transactionData['product_name'] as String,
          transactionId: (transactionData['TransactionId'] is int)
              ? transactionData['TransactionId'] as int
              : int.tryParse(transactionData['TransactionId'] as String) ?? 0,
        );

        callback(transaction);
      } else {
        Fluttertoast.showToast(
            msg: 'No transaction found for the  ID: $transactionId');
        print('No transaction found for the  transactionID: $transactionId');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des transactions');
    }
  }

  Future<void> deleteTransaction(int transactionId, Function callback) async {
    try {
      SellingDatabaseHelper dbHelper = SellingDatabaseHelper();
      bool isDeleted = await dbHelper.deleteTransactionToDB(transactionId);
      if (isDeleted) {
        transactionsList.removeWhere(
            (transaction) => transaction.transactionId == transactionId);
        callback();
      } else {
        Fluttertoast.showToast(
            msg: 'Aucune transaction trouvée avec le code: $transactionId');
      }
    } on Exception {
      Fluttertoast.showToast(
          msg: 'Erreur lors de la suppression de la transaction');
    }
  }
}
