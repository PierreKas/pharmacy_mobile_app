import 'package:fluttertoast/fluttertoast.dart';

import 'package:pharmacy/database/products_db/database_helper.dart';
import 'package:pharmacy/models/products.dart';
import 'package:pharmacy/services/notificationsService.dart';

class ProductsController {
  static List<Product> productsList = [];
  DateTime? expiryDate;
  DateTime currentDate = DateTime.now();
  String expiredProduct = '';

  Future<void> addProduct(Product product, Function callback) async {
    if (product.productCode.isEmpty || product.productName.isEmpty) {
      Fluttertoast.showToast(msg: 'Complète le nom du produit et son code');
      return;
    }

    try {
      ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
      await dbHelper.addProductToDB(product);
      productsList.add(product);
      callback();
      //getProducts(callback);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de l\'ajout du produit');
    }
  }

  Future<void> deleteProduct(String productCode, Function callback) async {
    try {
      ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
      bool isDeleted = await dbHelper.deleteProductToDB(productCode);
      if (isDeleted) {
        productsList
            .removeWhere((product) => product.productCode == productCode);
        callback();
      } else {
        Fluttertoast.showToast(
            msg: 'Aucun produit trouvé avec le code: $productCode');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de la suppression du produit');
    }
  }

  Future<void> updateProduct(Product product, Function callback) async {
    if (product.productCode.isEmpty ||
        product.productName.isEmpty ||
        product.purchasePrice <= 0 ||
        product.quantity <= 0 ||
        product.expiryDate == null) {
      Fluttertoast.showToast(msg: 'Veuillez remplir tous les champs requis');
      return;
    }
    try {
      ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
      await dbHelper.updateProductInDB(product);
      int index =
          productsList.indexWhere((p) => p.productCode == product.productCode);
      if (index != -1) {
        productsList[index] = product;
      }
      callback();
      await getProducts(callback);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur lors de la mise à jour du produit');
    }
  }

  Future<void> getProducts(Function callback) async {
    try {
      ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
      List<Map<String, dynamic>> productsData =
          await dbHelper.getProductsToDB();

      // usersList.clear();
      print('Raw product data: $productsData');
      DateTime twoMonthsFromNow =
          DateTime(currentDate.year, currentDate.month + 2, currentDate.day);
      print(twoMonthsFromNow);
      productsList = productsData.map((productData) {
        expiryDate = productData['expiry_date'] != null
            ? DateTime.parse(productData['expiry_date'] as String)
            : null;
        expiredProduct = productData['product_name'] as String;
        if (expiryDate!.isBefore(twoMonthsFromNow)) {
          final NotificationsService notificationsService =
              NotificationsService();
          notificationsService.showNotification(
            'La date d\'expiration approche',
            '''
Vérifie les dates d'expiration des médicaments du produit $expiredProduct
''',
          );
        }
        return Product(
          productCode: productData['product_code'] as String,
          productName: productData['product_name'] as String,
          purchasePrice: (productData['purchase_price'] is num)
              ? (productData['purchase_price'] as num).toDouble()
              : double.tryParse(productData['purchase_price'] as String) ?? 0.0,
          quantity: (productData['quantity'] is int)
              ? productData['quantity'] as int
              : int.tryParse(productData['quantity'] as String) ?? 0,
          expiryDate: productData['expiry_date'] != null
              ? DateTime.parse(productData['expiry_date'] as String)
              : null,
          sellingPrice: (productData['selling_price'] is num)
              ? (productData['selling_price'] as num).toDouble()
              : double.tryParse(productData['selling_price'] as String) ?? 0.0,
        );
      }).toList();
      print('Mapped products: $productsList');

      callback();
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des produits');
    }
  }
  //  Future<void> getClients2(Function(List<Client>) callback) async {
//     try {
//       ClientsDatabaseHelper dbHelper = ClientsDatabaseHelper();
//       List<Map<String, dynamic>> clientsData = await dbHelper.getClientsToDB();

//       clientsList = clientsData.map((clientData) {
//         return Client(
//             fullName: clientData['Full_name'],
//             phoneNumber: clientData['phone_number'],
//             password: clientData['pwd'],
//             clientId: (clientData['client_id'] is int)
//                 ? clientData['client_id'] as int
//                 : int.tryParse(clientData['client_id'] as String),
//             address: clientData['address']);
//       }).toList();

//       callback(clientsList);
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: 'Erreur lors de la récupération des données des clients');
//       print(e);
//     }
//   }
  Future<void> getProducts2(Function(List<Product>) callback) async {
    try {
      ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
      List<Map<String, dynamic>> productsData =
          await dbHelper.getProductsToDB();

      // usersList.clear();
      print('Raw product data: $productsData');
      DateTime twoMonthsFromNow =
          DateTime(currentDate.year, currentDate.month + 2, currentDate.day);
      print(twoMonthsFromNow);
      productsList = productsData.map((productData) {
        expiryDate = productData['expiry_date'] != null
            ? DateTime.parse(productData['expiry_date'] as String)
            : null;
        expiredProduct = productData['product_name'] as String;
        if (expiryDate!.isBefore(twoMonthsFromNow)) {
          final NotificationsService notificationsService =
              NotificationsService();
          notificationsService.showNotification(
            'La date d\'expiration approche',
            '''
Vérifie les dates d'expiration des médicaments du produit $expiredProduct
''',
          );
        }
        return Product(
          productCode: productData['product_code'] as String,
          productName: productData['product_name'] as String,
          purchasePrice: (productData['purchase_price'] is num)
              ? (productData['purchase_price'] as num).toDouble()
              : double.tryParse(productData['purchase_price'] as String) ?? 0.0,
          quantity: (productData['quantity'] is int)
              ? productData['quantity'] as int
              : int.tryParse(productData['quantity'] as String) ?? 0,
          expiryDate: productData['expiry_date'] != null
              ? DateTime.parse(productData['expiry_date'] as String)
              : null,
          sellingPrice: (productData['selling_price'] is num)
              ? (productData['selling_price'] as num).toDouble()
              : double.tryParse(productData['selling_price'] as String) ?? 0.0,
        );
      }).toList();
      print('Mapped products: $productsList');

      callback(productsList);
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des produits');
    }
  }

  Future<void> getProductInfo(String productCode, Function callback) async {
    try {
      ProductDatabaseHelper dbHelper = ProductDatabaseHelper();
      Map<String, dynamic>? productData =
          await dbHelper.getProductInfoToDB(productCode);

      // usersList.clear();
      print('Raw product data: $productData');

      if (productData != null) {
        Product product = Product(
          productCode: productData['product_code'] as String,
          productName: productData['product_name'] as String,
          purchasePrice: (productData['purchase_price'] is num)
              ? (productData['purchase_price'] as num).toDouble()
              : double.tryParse(productData['purchase_price'] as String) ?? 0.0,
          quantity: (productData['quantity'] is int)
              ? productData['quantity'] as int
              : int.tryParse(productData['quantity'] as String) ?? 0,
          expiryDate: productData['expiry_date'] != null
              ? DateTime.parse(productData['expiry_date'] as String)
              : null,
          sellingPrice: (productData['selling_price'] is num)
              ? (productData['selling_price'] as num).toDouble()
              : double.tryParse(productData['selling_price'] as String) ?? 0.0,
        );
        callback(product);
      } else {
        Fluttertoast.showToast(
            msg: 'No product found with the code: $productCode');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: 'Erreur lors de la récupération des produits');
    }
  }
}
