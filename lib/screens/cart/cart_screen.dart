import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:wellfreshlogin/controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var appBar = CustomAppBar(
      title: 'Cart',
      backButton: true,
      scaffoldKey: scaffoldKey
    );

    return StreamBuilder(
      // TODO: Change 1 to the logged user's ID
      stream: FirestoreServices.getCart(1),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            key: scaffoldKey,
            appBar: appBar,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else if (snapshot.data!.docs.isEmpty) {
          return Scaffold(
            key: scaffoldKey,
            appBar: appBar,
            body: const ItemIndicator(icon: IconlyBroken.buy, text: 'Cart is empty'),
          );
        }
        else {
          var data = snapshot.data!.docs;
          controller.calculate(data);
          controller.productSnapshot = data;

          return Scaffold(
            key: scaffoldKey,
            appBar: appBar,
            bottomNavigationBar: CustomNavBar(
              title: 'Proceed to Shipping',
              icon: const Icon(IconlyBroken.paper),
              action: () {
                Get.to(() => const ShippingScreen());
              },
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, int index) {
                        return CartProductCard(
                          id: data[index].id,
                          name: data[index]['name'],
                          category: data[index]['category'],
                          imageUrl: data[index]['imageUrl'],
                          price: data[index]['price'],
                          quantity: data[index]['quantity'],
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 16),
                  const OrderSummary(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
