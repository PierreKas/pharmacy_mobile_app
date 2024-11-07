import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/selling_point_db/database_helper.dart';
import 'package:pharmacy/models/selling_points.dart';

class SellingPointController {
  static List<SellingPoint> sellingPointsList = [];

  Future<void> addSellingPoint(
      SellingPoint sellingPoint, Function callback) async {
    if (sellingPoint.name!.isEmpty) {
      Fluttertoast.showToast(msg: 'Complète le nom de la succursale');
      return;
    }

    try {
      SellingPointDatabaseHelper dbHelper = SellingPointDatabaseHelper();
      await dbHelper.addSellingPointToDB(sellingPoint);
      sellingPointsList.add(sellingPoint);
      callback();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de l\'ajout du produit');
    }
  }

  Future<void> deleteSellingPoint(int id, Function callback) async {
    try {
      SellingPointDatabaseHelper dbHelper = SellingPointDatabaseHelper();
      bool isDeleted = await dbHelper.deleteSellingPointToDB(id);
      if (isDeleted) {
        sellingPointsList.removeWhere((sellingPt) => sellingPt.id == id);
        callback();
      } else {
        Fluttertoast.showToast(msg: 'Aucune succursale trouvée');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de la suppression du produit');
    }
  }

  Future<void> updateSellingPoint(
      SellingPoint sellingPoint, Function callback) async {
    if (sellingPoint.name!.isEmpty) {
      Fluttertoast.showToast(msg: 'Veuillez remplir tous les champs requis');
      return;
    }
    try {
      SellingPointDatabaseHelper dbHelper = SellingPointDatabaseHelper();
      await dbHelper.updateSellingPointInDB(sellingPoint);
      int index = sellingPointsList
          .indexWhere((sellingPt) => sellingPt.id == sellingPt.id);
      if (index != -1) {
        sellingPointsList[index] = sellingPoint;
      }
      callback();
      await getSellingPoints(callback);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de la mise à jour du produit');
    }
  }

  Future<void> getSellingPoints(Function callback) async {
    try {
      SellingPointDatabaseHelper dbHelper = SellingPointDatabaseHelper();
      List<Map<String, dynamic>> sellingPointsData =
          await dbHelper.getSellingPointsToDB();

      sellingPointsList = sellingPointsData.map((sellingPtData) {
        return SellingPoint(
          name: sellingPtData['name'] as String,
          id: (sellingPtData['id'] is int)
              ? sellingPtData['id'] as int
              : int.tryParse(sellingPtData['id'] as String) ?? 0,
        );
      }).toList();
      callback();
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des données des succursale');
    }
  }

  Future<void> getSellingPoints2(Function(List<SellingPoint>) callback) async {
    try {
      SellingPointDatabaseHelper dbHelper = SellingPointDatabaseHelper();
      List<Map<String, dynamic>> sellingPointsData =
          await dbHelper.getSellingPointsToDB();

      sellingPointsList = sellingPointsData.map((sellingPtData) {
        return SellingPoint(
          name: sellingPtData['name'] as String,
          id: (sellingPtData['id'] is int)
              ? sellingPtData['id'] as int
              : int.tryParse(sellingPtData['id'] as String) ?? 0,
        );
      }).toList();
      callback(sellingPointsList);
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des données des succursales');
    }
  }

  Future<void> getSellingPointInfo(int id, Function callback) async {
    try {
      SellingPointDatabaseHelper dbHelper = SellingPointDatabaseHelper();
      Map<String, dynamic>? sellingPtData =
          await dbHelper.getSellingPointInfoToDB(id);

      if (sellingPtData != null) {
        SellingPoint sellingPoint = SellingPoint(
          name: sellingPtData['name'] as String,
          id: (sellingPtData['id'] is int)
              ? sellingPtData['id'] as int
              : int.tryParse(sellingPtData['id'] as String) ?? 0,
        );
        callback(sellingPoint);
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des données des succursales');
    }
  }
}
