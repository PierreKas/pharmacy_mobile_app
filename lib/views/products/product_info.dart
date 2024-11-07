import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/controllers/products_controller.dart';
import 'package:pharmacy/models/products.dart';
import 'package:pharmacy/views/products/update_product.dart';

class ProductInfo extends StatefulWidget {
  final String productCode;
  const ProductInfo({super.key, required this.productCode});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  bool isLoading = true;
  Product? _product;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProductInfo();
  }

  Future<void> _fetchProductInfo() async {
    try {
      await ProductsController().getProductInfo(widget.productCode, (product) {
        setState(() {
          _product = product;
          isLoading = false;
        });
      });
    } catch (e) {
      print('Error fetching product info: $e');
      Fluttertoast.showToast(msg: 'Error fetching product info: $e');
    }
  }

  Future<void> _deleteProduct() async {
    try {
      await ProductsController().deleteProduct(widget.productCode, () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'Produit supprimé');
      });
    } catch (e) {
      print('Error deleting product: $e');
      Fluttertoast.showToast(msg: 'Error deleting product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      body: //_product == null
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Colors.blue, strokeWidth: 5.0),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Product details for :',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          _product!.productName,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 240.0),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateProduct(
                                                            productCode: _product!
                                                                .productCode),
                                                  ),
                                                );
                                              },
                                              child: const Icon(Icons.edit)),
                                          // const SizedBox(
                                          //   width: 8,
                                          // ),
                                          // GestureDetector(
                                          //     onTap: () async {
                                          //       await _deleteProduct();
                                          //     },
                                          //     child: const Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Product Code:',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              _product!.productCode,
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                              'Purchase price: ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              'Fc${_product!.purchasePrice}',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                              'Expiry date: ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              '${_product!.expiryDate}',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                              'Quantity: ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              '${_product!.quantity}',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
