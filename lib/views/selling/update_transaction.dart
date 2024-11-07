import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/selling_controller.dart';
import 'package:pharmacy/models/selling.dart';
import 'package:pharmacy/views/selling/bill.dart';

// ignore: must_be_immutable
class UpdateTransaction extends StatefulWidget {
  int? transactionId;
  UpdateTransaction({super.key, required this.transactionId});

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  late TextEditingController _transactionIdController;

  final TextEditingController _productName = TextEditingController();

  final TextEditingController _unitPrice = TextEditingController();

  final TextEditingController _quantity = TextEditingController();

  bool isLoading = false;
  Selling _transaction = Selling();

  @override
  void dispose() {
    // TODO: implement dispose
    _transactionIdController.dispose();
    _productName.dispose();
    _unitPrice.dispose();
    _quantity.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactionIdController =
        TextEditingController(text: widget.transactionId.toString());
    // _productName = TextEditingController(text: selling.productName);
    // _unitPrice = TextEditingController(text: selling.unitPrice.toString());
    // _quantity = TextEditingController(text: selling.quantity.toString());
    initiateTextFields();
  }

  void initiateTextFields() async {
    // Selling updatedTransaction = Selling(
    //     transactionId: widget.transactionId ?? 0,
    //     productName: _productName.text,
    //     unitPrice: double.tryParse(_unitPrice.text) ?? 0.0,
    //     quantity: int.tryParse(_quantity.text) ?? 0);

    await SellsController()
        .getTransactionInfoByTransactionId(widget.transactionId, (transaction) {
      setState(() {
        _transaction = transaction;
        _productName.text = _transaction.productName ?? '';
        _quantity.text = _transaction.quantity.toString();
        _unitPrice.text = _transaction.unitPrice.toString();

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      body: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const Text(
                      'YEREMIYA PHARMACY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 73, 71, 71)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Modifier les informations de la transaction',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 200.0),
                      child: Text(
                        'Code du produit',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _transactionIdController,
                      cursorColor: Colors.grey,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: const Icon(
                          Icons.qr_code,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 200.0),
                      child: Text(
                        'Nom du produit',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _productName,
                      cursorColor: Colors.grey,
                      enabled: false,
                      decoration: InputDecoration(
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
                          Icons.medication_liquid_sharp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 230.0),
                      child: Text(
                        'Prix',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _unitPrice,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
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
                          Icons.monetization_on,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 250.0),
                      child: Text(
                        'Quantité',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _quantity,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
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
                          Icons.numbers,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String productName = _productName.text;
                        String quantityStr = _quantity.text;
                        String unitPriceStr = _unitPrice.text;

                        int quantity = int.tryParse(quantityStr) ?? 0;

                        double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;

                        Selling updatedTransaction = Selling(
                            transactionId: widget.transactionId,
                            productName: productName,
                            unitPrice: unitPrice,
                            quantity: quantity);
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        SellsController().updateTransactionOnBillCode(
                            updatedTransaction, () async {
                          int? billCode;

                          billCode = await SellsController().getLastBillCode();

                          print(billCode);
                          if (billCode != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Bill(
                                        billCode: billCode,
                                      )),
                            );
                          }
                        });

                        _productName.clear();
                        _unitPrice.clear();
                        _quantity.clear();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Modifier',
                              style: TextStyle(
                                color: Color.fromARGB(255, 238, 237, 237),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
