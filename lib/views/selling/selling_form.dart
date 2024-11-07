import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/controllers/clients_controller.dart';
import 'package:pharmacy/controllers/products_controller.dart';
import 'package:pharmacy/controllers/selling_controller.dart';
import 'package:pharmacy/models/client.dart';
import 'package:pharmacy/models/products.dart';
import 'package:pharmacy/models/selling.dart';
import 'package:pharmacy/views/selling/bill.dart';
import 'package:pharmacy/views/selling/daily_transactions.dart';

// ignore: must_be_immutable
class SellingForm extends StatefulWidget {
  int userId;
  SellingForm({super.key, required this.userId});

  @override
  State<SellingForm> createState() => _AddProductState();
}

class _AddProductState extends State<SellingForm> {
  final TextEditingController _productCode = TextEditingController();

  final TextEditingController _unitPrice = TextEditingController();

  final TextEditingController _totalPrice = TextEditingController();

  final TextEditingController _quantity = TextEditingController();

  final TextEditingController _userId = TextEditingController();

  final TextEditingController _clientId = TextEditingController();

  bool isLoading = false;
  List<Client> clients = [];
  Client? selectedClient;
  int? selectedClientId;
  List<Product> products = [];
  Product? selectedProduct;
  String? selectedProductCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quantity.addListener(_calculateTotalPrice);
    _unitPrice.addListener(_calculateTotalPrice);
    _userId.text = widget.userId.toString();
    _fetchClients();
    _fetchProducts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productCode.dispose();
    _unitPrice.dispose();
    _totalPrice.dispose();
    _quantity.dispose();
    _userId.dispose();
    _clientId.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    int quantity = int.tryParse(_quantity.text) ?? 0;
    double unitPrice = double.tryParse(_unitPrice.text) ?? 0.0;
    double totalPrice = quantity * unitPrice;

    setState(() {
      _totalPrice.text = totalPrice.toStringAsFixed(2);
    });
  }

  void _fetchClients() async {
    await ClientsController().getClients2((List<Client> fetchedClients) {
      setState(() {
        clients = fetchedClients;
      });
    });
  }

  void _fetchProducts() async {
    await ProductsController().getProducts2((List<Product> fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de vente'),
        backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'YEREMIYA PHARMACY',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 73, 71, 71)),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      onTap: () {
                                        DateTime selectedDate = DateTime.now();
                                        DateTime dateOnly = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DailyTransactionsList(
                                                    sellingDate: dateOnly,
                                                  )),
                                        );
                                      },
                                      child: const Text('Ventes journalières')),
                                  PopupMenuItem(
                                      onTap: () async {
                                        int? billCode;

                                        billCode = await SellsController()
                                            .getLastBillCode();
                                        Fluttertoast.showToast(
                                            msg: '$billCode');
                                        print(billCode);
                                        if (billCode != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Bill(
                                                      billCode: billCode,
                                                    )),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Cannot proceed because bill code is null');
                                        }
                                      },
                                      child: const Text('Voir la facture')),
                                ])
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Enregistrer les ventes via cette page',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
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
                    GestureDetector(
                      onTap: () {
                        _fetchProducts();
                      },
                      child: DropdownButtonFormField<String>(
                        value: selectedProductCode,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            )),
                        items: products.isEmpty
                            ? []
                            : products.map((Product product) {
                                return DropdownMenuItem<String>(
                                  value: product.productCode,
                                  child: Text(product.productName),
                                );
                              }).toList(),
                        onChanged: (String? newProductCode) {
                          setState(() {
                            selectedProductCode = newProductCode;

                            selectedProduct = products.firstWhere((product) =>
                                product.productCode == newProductCode);

                            if (selectedProduct != null) {
                              _unitPrice.text =
                                  selectedProduct!.sellingPrice.toString();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 200.0),
                      child: Text(
                        'Prix unitaire',
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
                      enabled: false,
                      decoration: InputDecoration(
                        //hintText: ,
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
                          Icons.monetization_on_outlined,
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
                    const Padding(
                      padding: EdgeInsets.only(right: 230.0),
                      child: Text(
                        'Prix total',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _totalPrice,
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
                          Icons.monetization_on,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 150.0),
                      child: Text(
                        'Code du vendeur',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _userId,
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
                          Icons.circle,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 150.0),
                      child: Text(
                        'Nom du client',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _fetchClients();
                      },
                      child: DropdownButtonFormField<int>(
                        value: selectedClientId,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.circle_outlined,
                              color: Colors.blue,
                            )),
                        items: clients.isEmpty
                            ? []
                            : clients.map((Client client) {
                                return DropdownMenuItem<int>(
                                  value: client.clientId,
                                  child: Text(client.fullName),
                                );
                              }).toList(),
                        onChanged: (int? newClientId) {
                          setState(() {
                            selectedClientId = newClientId;
                            selectedClient = clients.firstWhere(
                                (client) => client.clientId == newClientId);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String productCode = _productCode.text;
                        String unitPriceStr = _unitPrice.text;
                        String quantityStr = _quantity.text;
                        String totalPriceStr = _totalPrice.text;
                        String userId = _userId.text;
                        String clientId = selectedClient!.clientId.toString();
                        int quantity = int.tryParse(quantityStr) ?? 0;
                        double unitPrice = double.tryParse(unitPriceStr) ?? 0.0;
                        double totalPrice =
                            double.tryParse(totalPriceStr) ?? 0.0;

                        Selling newTransaction = Selling(
                            productCode: productCode,
                            unitPrice: unitPrice,
                            totalPrice: totalPrice,
                            userId: int.tryParse(userId),
                            clientId: int.tryParse(clientId),
                            quantity: quantity);
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        SellsController().addTransaction(newTransaction, () {});

                        _productCode.clear();
                        _totalPrice.clear();
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
                              'Ajouter',
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
