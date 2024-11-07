import 'dart:io';
//import 'dart:js_interop';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/controllers/products_controller.dart';
import 'package:pharmacy/controllers/selling_controller.dart';
import 'package:pharmacy/customizable_widget/pdf_generator_widget.dart';
import 'package:pharmacy/models/selling.dart';

class DailyTransactionsList extends StatefulWidget {
  final DateTime sellingDate;
  const DailyTransactionsList({super.key, required this.sellingDate});

  @override
  State<DailyTransactionsList> createState() => _DailyTransactionsList();
}

class _DailyTransactionsList extends State<DailyTransactionsList> {
  final ScrollController _scrollController = ScrollController();
  double _floattingButOpacity = 1.0;
  final TextEditingController _searchedDate = TextEditingController();
  bool isLoading = true;

  DateTime? _selectedDate;
  // final DateTime? sellingDate;
  List<Selling> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactionsBydate();
    _scrollController.addListener(() {
      _handleScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchedDate.dispose();
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

  void _fetchTransactionsBydate() async {
    await SellsController().getSellingInfoByDate(widget.sellingDate,
        (transactions) {
      setState(() {
        _transactions = transactions;
        isLoading = false;
      });
    });
  }

  // Future<void> _downloadPDF() async {
  //   var status = await Permission.storage.request();
  //   print('Permission Status: $status');
  //   if (status.isGranted) {
  //     var pdf = pw.Document();

  //     List<pw.TableRow> tableRows = [
  //       pw.TableRow(children: [
  //         pw.Padding(
  //           padding: const pw.EdgeInsets.all(16),
  //           child: pw.Text(
  //             'Product name',
  //             style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //           ),
  //         ),
  //         pw.Padding(
  //           padding: const pw.EdgeInsets.all(16),
  //           child: pw.Text(
  //             'Unit price',
  //             style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //           ),
  //         ),
  //         pw.Padding(
  //           padding: const pw.EdgeInsets.all(18),
  //           child: pw.Text(
  //             'Quantity',
  //             style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //           ),
  //         ),
  //         pw.Padding(
  //           padding: const pw.EdgeInsets.all(18),
  //           child: pw.Text(
  //             'Total price',
  //             style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //           ),
  //         )
  //       ]),
  //       for (var selling in _transactions)
  //         pw.TableRow(children: [
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(16),
  //             child: pw.Text(
  //               selling.productName!,
  //               style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(16),
  //             child: pw.Text(
  //               selling.unitPrice.toString(),
  //               style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(18),
  //             child: pw.Text(
  //               selling.quantity.toString(),
  //               style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(18),
  //             child: pw.Text(
  //               selling.totalPrice.toString(),
  //               style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
  //             ),
  //           )
  //         ]),
  //     ];
  //     pdf.addPage(pw.Page(
  //         build: (pw.Context context) => pw.Table(
  //             border: pw.TableBorder.all(color: PdfColors.black),
  //             children: tableRows)));
  //     Directory? directory = await getExternalStorageDirectory();
  //     if (directory != null) {
  //       String outputFile = '${directory.path}/Download/$_selectedDate.pdf';
  //       File file = File(outputFile);
  //       await file.create(recursive: true);
  //       await file.writeAsBytes(await pdf.save());
  //       Fluttertoast.showToast(msg: 'PDF downloaded');
  //     } else {
  //       Fluttertoast.showToast(msg: 'Failed to store');
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: 'Download failed');
  //   }
  // }

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
    print('Number of transactions: ${SellsController.transactionsList.length}');

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  children: [
                    Table(
                        border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FlexColumnWidth(1.5),
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
                                    'Noms',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Prix unitaire',
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
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Prix total',
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
                            ? const SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.blue, strokeWidth: 5.0),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  Selling selling = _transactions[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Table(
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      columnWidths: const {
                                        0: FlexColumnWidth(1.5),
                                        1: FlexColumnWidth(1.5),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(1.5),
                                      },
                                      children: [
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              selling.productName!,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              selling.unitPrice.toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18),
                                            child: Text(
                                              selling.quantity.toString(),
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18),
                                            child: Text(
                                              selling.totalPrice.toString(),
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
            child: Column(
              children: [
                const Text('Entrer la date',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                const SizedBox(height: 15),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchedDate,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          // labelText: 'Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(80.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.calendar_today, // Adjust icon as needed
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              initialDate: DateTime.now());
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _searchedDate.text = _selectedDate!
                                  .toIso8601String()
                                  .split('T')
                                  .first;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 0,
                    ),
                    GestureDetector(
                        onTap: () {
                          // _fetchTransactionsBydate();
                          SellsController().getSellingInfoByDate(_selectedDate!,
                              (transaction) {
                            setState(() {
                              _transactions = transaction;
                            });
                          });
                        },
                        child: const Icon(Icons.refresh)
                        // child: Container(
                        //   height: 20,
                        //   width: 20,
                        //   decoration: const BoxDecoration(color: Colors.blue),
                        // ),
                        )
                  ],
                ),
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
                    onPressed: () {
                      // _downloadPDF();
                      PdfGeneratorWidget pdfGenerator = PdfGeneratorWidget(
                          fileName: 'Trans$_selectedDate',
                          transactions: _transactions.map((selling) {
                            return {
                              'Product name': selling.productName,
                              'unit price': selling.unitPrice.toString(),
                              'Quantity': selling.quantity.toString(),
                              'Total price': selling.totalPrice.toString()
                            };
                          }).toList(),
                          headers: [
                            'Product name',
                            'Prix unitaire',
                            'Quantité',
                            'Prix total'
                          ]);
                      pdfGenerator.downloadPDF();
                    },
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return const AddProduct();
                      // }));
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
