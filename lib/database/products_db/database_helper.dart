import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/database/conn_string.dart';
import 'package:pharmacy/models/products.dart';

class ProductDatabaseHelper {
  Future<List<Map<String, dynamic>>> getProductsToDB() async {
    final conn = await DatabaseHelper.getConnection();
    const sql = 'SELECT * FROM products';
    if (conn == null) {
      return [];
    }
    try {
      final results = await conn.execute(sql);
      final products = results.rows.map((row) => row.assoc()).toList();

      print('Products retrived successfully');
      Fluttertoast.showToast(msg: 'Produits récupérés avec succès');

      return products;
    } catch (e) {
      print('Error during SELECT operation: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>?> getProductInfoToDB(String productCode) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }
    const sql = 'SELECT * FROM products WHERE product_code= :productCode';

    try {
      final results = await conn.execute(sql, {'productCode': productCode});
      if (results.rows.isNotEmpty) {
        final product = results.rows.first.assoc();
        print('Product info retrieved successfully');
        Fluttertoast.showToast(msg: 'Product info retrieved successfully');
        return product;
      } else {
        print('No product found with the code :$productCode');
        Fluttertoast.showToast(
            msg: 'No product found with the code :$productCode');
        return null;
      }
    } catch (e) {
      print('Error during SELECT operation: $e');
      return null;
    } finally {
      await conn.close();
    }
  }

  Future<bool> deleteProductToDB(String productCode) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return false;
    }
    const sql = 'DELETE FROM products WHERE product_code= :productCode';

    try {
      final results = await conn.execute(sql, {'productCode': productCode});
      if (results.rows.isNotEmpty) {
        results.rows.first.assoc();
        print('Product deleted successfully');
        Fluttertoast.showToast(msg: 'Product deleted successfully');
        return true;
      } else {
        print('No product found with the code :$productCode');
        Fluttertoast.showToast(
            msg: 'No product found with the code :$productCode');
        return false;
      }
    } catch (e) {
      print('Error during DELETE operation: $e');
      return false;
    } finally {
      await conn.close();
    }
  }

  Future<void> addProductToDB(Product product) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return;
    }
    final sql = '''
    INSERT INTO products (product_code, product_name, purchase_price, quantity, expiry_date,selling_price) 
    VALUES (
      '${product.productCode}', 
      '${product.productName}', 
      '${product.purchasePrice}', 
      '${product.quantity}', 
      '${product.expiryDate}',
      '${product.sellingPrice}'
    )
  ''';

    try {
      await conn.execute(sql);
      print('product added successfully');
      Fluttertoast.showToast(msg: 'Produit ajouté');
    } catch (e) {
      if (e
          .toString()
          .contains('This medecine will expiry in one month or less')) {
        Fluttertoast.showToast(
            msg: 'Ce medicament va expirer dans un mois ou moins');
      } else {
        print('Error during INSERT operation: $e');
        Fluttertoast.showToast(msg: 'Tes données contiennent une erreur');
      }
    } finally {
      await conn.close();
    }
  }

  Future<Map<String, dynamic>?> updateProductInDB(Product product) async {
    final conn = await DatabaseHelper.getConnection();
    if (conn == null) {
      return null;
    }
    final sql = '''
  UPDATE products 
  SET 
    product_name = '${product.productName}', 
    purchase_price = '${product.purchasePrice}', 
    quantity = '${product.quantity}', 
    expiry_date = '${product.expiryDate}',
    selling_price = '${product.sellingPrice}', 
  WHERE 
    product_code = '${product.productCode}'
  ''';
    try {
      final results = await conn.execute(sql);
      if (results.affectedRows.toInt() > 0) {
        print('Product updated successfully');
        Fluttertoast.showToast(msg: 'Product updated successfully');
      } else {
        print('No product found with the code :${product.productCode}');
        Fluttertoast.showToast(
            msg: 'No product found with the code :${product.productCode}');
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
