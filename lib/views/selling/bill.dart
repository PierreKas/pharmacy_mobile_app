import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy/controllers/selling_controller.dart';
import 'package:pharmacy/models/selling.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pharmacy/services/notificationsService.dart';
import 'package:pharmacy/views/selling/update_transaction.dart';

// ignore: must_be_immutable
class Bill extends StatefulWidget {
  int? billCode;

  Bill({super.key, required this.billCode});

  @override
  State<Bill> createState() => _Bill();
}

class _Bill extends State<Bill> {
  final ScrollController _scrollController = ScrollController();
  final List<TextEditingController> _quantityController = [];
  final List<TextEditingController> _unitPriceController = [];
  final List<TextEditingController> _totalPriceController = [];
  final List<TextEditingController> _sellingDateController = [];
  final List<TextEditingController> _productNameController = [];
  final List<TextEditingController> _transCodeController = [];
  double _floattingButOpacity = 1.0;
  bool isLoading = true;
  final List<Selling> _transactions = [];
  Selling selling = Selling();
// Future<int?> getBillCode() async{
//   int? billCode = await SellsController().getLastBillCode();
//   return billCode;
// }
  @override
  void initState() {
    super.initState();
    _fetchTransactionsByBillCode();
    _scrollController.addListener(() {
      _handleScroll();
    });
  }

  @override
  void dispose() {
    for (var controller in _quantityController) {
      controller.dispose();
    }
    for (var controller in _productNameController) {
      controller.dispose();
    }
    for (var controller in _sellingDateController) {
      controller.dispose();
    }
    for (var controller in _totalPriceController) {
      controller.dispose();
    }
    for (var controller in _transCodeController) {
      controller.dispose();
    }
    for (var controller in _unitPriceController) {
      controller.dispose();
    }
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

  void _fetchTransactionsByBillCode() async {
    await SellsController().getTransactionInfoByBillCode(widget.billCode,
        (transactions) {
      setState(() {
        _transactions.addAll(transactions);
        isLoading = false;
        for (var transaction in transactions) {
          _quantityController.add(
              TextEditingController(text: transaction.quantity.toString()));
          _productNameController
              .add(TextEditingController(text: transaction.productName));
          _unitPriceController.add(
              TextEditingController(text: transaction.unitPrice.toString()));
          _totalPriceController.add(
              TextEditingController(text: transaction.totalPrice.toString()));
          _sellingDateController.add(
              TextEditingController(text: transaction.sellingDate.toString()));
          _transCodeController.add(TextEditingController(
              text: transaction.transactionId.toString()));
        }
      });
    });
  }

  Future<void> _downloadPDF() async {
    var permissionStatuts = await Permission.storage.request();
    if (permissionStatuts.isGranted) {
      var pdf = pw.Document();
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) => pw.Column(children: [
          pw.Text('---------------------------------------------------------'),
          pw.Text('YEREMIYA PHARMACY'),
          pw.Text('Adresse RDC/Goma'),
          pw.Text('yeremiyapharma@gmail.com '),
          pw.Text('+243 999 999 999 '),
          pw.Text('---------------------------------------------------------'),
          pw.Text('FACT${widget.billCode}'),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Produits'),
                pw.Text('Qty'),
                pw.Text('PU'),
                pw.Text('Total')
              ]),
          pw.Text('---------------------------------------------------------'),
          ...List.generate(_transactions.length, (index) {
            Selling selling = _transactions[index];
            return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(selling.productName!),
                  pw.Text(selling.quantity.toString()),
                  pw.Text(selling.unitPrice.toString()),
                  pw.Text(selling.totalPrice.toString()),
                ]);
          }),
          pw.Text('---------------------------------------------------------'),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Montant Total'),
                pw.Text(
                    '${_transactions.fold(0, (total, selling) => total + (selling.totalPrice!).toInt())} Fc',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]),
          pw.Text('---------------------------------------------------------'),
          pw.SizedBox(height: 15),
          pw.Text('***************************************************'),
          pw.Text('  Merci, vient encore prochainement'),
          pw.Text('***************************************************'),
          pw.Text('Software developed by: Pierre KASANANI'),
          pw.Text('chikukaspierre@gmail.com ')
        ]),
      ));
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        String outputFile =
            '${directory.path}/Download/FACT${widget.billCode}.pdf';
        File file = File(outputFile);
        await file.create(recursive: true);
        await file.writeAsBytes(await pdf.save());
        final NotificationsService notificationsService =
            NotificationsService();
        notificationsService.showNotification(
            'Tape ici pour ouvrir', 'Facture téléchargée',
            playload: outputFile);
        Fluttertoast.showToast(
            msg: 'Facture téléchargée, tape la notification pour ouvrir');
      } else {
        Fluttertoast.showToast(msg: 'Stockage échoué');
      }
    } else {
      Fluttertoast.showToast(msg: 'Erreur de téléchargement');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('Number of transactions: ${SellsController.transactionsList.length}');

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Text(
                      'Facture N*${widget.billCode}',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    //  const Text('Facture N*}'),
                    const SizedBox(
                      height: 15,
                    ),
                    NotificationListener<UserScrollNotification>(
                      onNotification: (UserScrollNotification notification) {
                        if (notification.direction == ScrollDirection.idle) {
                          _handleScroll();
                        }
                        return false;
                      },
                      child: Expanded(
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          isLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.blue,
                                                          strokeWidth: 5.0),
                                                )
                                              : DataTable(columns: const [
                                                  DataColumn(
                                                      label: Text(
                                                    'Num',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label: Text(
                                                    'Produit',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label: Text(
                                                    'Prix unitaire',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label: Text(
                                                    'Quantité',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label: Text(
                                                    'Prix total',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label: Text(
                                                    'Date',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                  DataColumn(
                                                      label: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ))
                                                ], rows: [
                                                  ...List.generate(
                                                      _transactions.length,
                                                      (index) {
                                                    Selling selling =
                                                        _transactions[index];

                                                    return DataRow(cells: [
                                                      DataCell(Text(selling
                                                          .transactionId
                                                          .toString())),
                                                      DataCell(Text(selling
                                                          .productName!)),
                                                      DataCell(Text(selling
                                                          .unitPrice
                                                          .toString())),
                                                      DataCell(Text(selling
                                                          .quantity
                                                          .toString())),
                                                      DataCell(Text(selling
                                                          .totalPrice
                                                          .toString())),
                                                      DataCell(Text(selling
                                                          .sellingDate
                                                          .toString())),
                                                      DataCell(Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          UpdateTransaction(
                                                                              transactionId: selling.transactionId)));
                                                            },
                                                            child: const Icon(
                                                                Icons.edit),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                            title:
                                                                                const Text(''),
                                                                            content:
                                                                                const Text(
                                                                              'Veux-tu vraiment supprimer cette transaction?',
                                                                              style: TextStyle(
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Non',
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                                                      )),
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        SellsController().deleteTransaction(selling.transactionId!, () {});
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: const Text(
                                                                                        'Oui',
                                                                                        style: TextStyle(color: Colors.black),
                                                                                      ))
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ));
                                                            },
                                                            child: const Icon(Icons
                                                                .delete_outline_outlined),
                                                          ),
                                                        ],
                                                      ))
                                                    ]);
                                                  })
                                                ]),
                                        ],
                                      ),
                                    )),
                              ],
                            )
                          ],

                          // print(
                          //     'Bill page shows :${selling.billCode} as billCode');
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

          Positioned(
            bottom: 10,
            right: 20,
            child: Row(
              children: [
                Opacity(
                  opacity: _floattingButOpacity,
                  child: FloatingActionButton(
                    onPressed: () {
                      _downloadPDF();
                      SellsController().setBillCode();
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.download),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // Opacity(
                //   opacity: _floattingButOpacity,
                //   child: FloatingActionButton(
                //     onPressed: () {

                //     },
                //     backgroundColor: Colors.blue,
                //     child: const Icon(Icons.check),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
