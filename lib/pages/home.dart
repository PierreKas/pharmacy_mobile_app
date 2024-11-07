import 'package:flutter/material.dart';
import 'package:pharmacy/controllers/products_controller.dart';
import 'package:pharmacy/controllers/users_controller.dart';
import 'package:pharmacy/models/products.dart';
import 'package:pharmacy/pages/login_page.dart';
import 'package:pharmacy/views/clients/clients_list.dart';
import 'package:pharmacy/views/products/products_list.dart';
import 'package:pharmacy/views/selling/selling_form.dart';
import 'package:pharmacy/views/selling_points/displayList.dart';
import 'package:pharmacy/views/users/users_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    await ProductsController().getProducts(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      appBar: AppBar(
        title: const Text(
          'YEREMIYA PHARMACY',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_outlined));
        }),
        backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu'),
            ),
            if (UsersController.userRole.toLowerCase() == 'admin')
              ListTile(
                title: const Text('Utilisateurs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsersList()),
                  );
                },
              ),
            ListTile(
              title: const Text('Succursales'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellingPointsList()),
                );
              },
            ),
            if (UsersController.userRole.toLowerCase() != 'seller')
              ListTile(
                title: const Text('Produits'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductsList()),
                  );
                },
              ),
            ListTile(
              title: const Text('Ventes'),
              onTap: () {
                int userId = UsersController.userId;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SellingForm(
                            userId: userId,
                          )),
                );
              },
            ),
            ListTile(
              title: const Text('Clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClientsList()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
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
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nos produits disponibles',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color.fromARGB(255, 71, 69, 69)),
                      ),
                      GestureDetector(
                          onTap: () {
                            _fetchProducts();
                          },
                          child: const Icon(Icons.refresh))
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75),
                      itemCount: ProductsController.productsList.length,
                      itemBuilder: (context, index) {
                        Product product =
                            ProductsController.productsList[index];
                        return Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/professional-medical-doctor-hand-giving-medicine-photo.jpg',
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                                Text(
                                  product.productName,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Prix:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      product.sellingPrice.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
