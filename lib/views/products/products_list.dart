import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/controllers/products_controller.dart';
import 'package:pharmacy/models/products.dart';
import 'package:pharmacy/views/products/add_product.dart';
import 'package:pharmacy/views/products/product_info.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final ScrollController _scrollController = ScrollController();
  double _floattingButOpacity = 1.0;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
    _scrollController.addListener(() {
      _handleScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _floattingButOpacity = 0.2;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _floattingButOpacity = 1.0;
      });
    }
  }

  void _fetchProducts() async {
    await ProductsController().getProducts(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _downloadExcel() async {
    try {
      var status = await Permission.storage.request();
      print('Permission Status: $status');
      if (status.isGranted) {
        var excel = Excel.createExcel();
        Sheet sheetObject = excel['Products'];
        sheetObject.appendRow([
          'Product name',
          'Purchase price',
          'Quantity',
        ]);

        for (var product in ProductsController.productsList) {
          sheetObject.appendRow([
            product.productName,
            product.purchasePrice.toString(),
            product.quantity.toString(),
          ]);
        }
        Directory? directory = await getExternalStorageDirectory();
        String outputFile = '${directory?.path}/Download/productsStock.xlsx';
        File(outputFile)
          ..createSync(recursive: true)
          ..writeAsBytesSync(excel.save()!);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Excel file saved at $outputFile')),
        // );
        Fluttertoast.showToast(msg: 'Excel file downloaded to $outputFile');
      } else {
        // print('Permission denied. Status: $status');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Permission denied')),
        // );
        Fluttertoast.showToast(msg: 'Download failed');
      }
    } catch (e) {
      // print('Exception: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('An error occurred')),
      // );
      Fluttertoast.showToast(msg: 'There is an error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Number of products: ${ProductsController.productsList.length}');
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Liste des médicaments'),
      //   backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.only(top: 64),
                child: Column(
                  children: [
                    Table(
                        border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1.5),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: const [
                          TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.blueAccent),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Code',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Nom',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Prix d\'achat',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Quantité',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                )
                              ]),
                        ]),
                    const SizedBox(
                      height: 0,
                    ),
                    NotificationListener<UserScrollNotification>(
                      onNotification: (UserScrollNotification notification) {
                        if (notification.direction == ScrollDirection.idle) {
                          _handleScroll();
                        }
                        return false;
                      },
                      child: Expanded(
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue, strokeWidth: 5.0),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    ProductsController.productsList.length,
                                itemBuilder: (context, index) {
                                  Product product =
                                      ProductsController.productsList[index];
                                  print(
                                      'Rendering product: ${product.productName}');

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Table(
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      columnWidths: const {
                                        0: FlexColumnWidth(1),
                                        1: FlexColumnWidth(1.5),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(1.5),
                                      },
                                      children: [
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              product.productCode,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              final prCode =
                                                  product.productCode;
                                              Colors.blue;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductInfo(
                                                          productCode: prCode),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                product.productName,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              product.purchasePrice.toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18),
                                            child: Text(
                                              product.quantity.toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                          )
                                        ]),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                )),
          ),
          Positioned.fill(
              child: Center(
            child: Opacity(
              opacity: 0.2,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/logo-no-background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          //   child: ElevatedButton(
          //       onPressed: () {}, child: const Icon(Icons.add_box_outlined)),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Row(
              children: [
                const Text('Stock des médicaments',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                    onTap: () {
                      _fetchProducts();
                    },
                    child: const Icon(Icons.refresh))
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: Row(
              children: [
                Opacity(
                  opacity: _floattingButOpacity,
                  child: FloatingActionButton(
                    onPressed: _downloadExcel,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.download),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Opacity(
                  opacity: _floattingButOpacity,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AddProduct();
                      }));
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add_box_outlined),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
