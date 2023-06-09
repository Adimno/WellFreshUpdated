import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/services/firebase_services.dart';
import 'package:wellfresh/controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var userId = FirebaseAuth.instance.currentUser!.uid;

    var appBar = CustomAppBar(
      title: 'Cart',
      backButton: true,
      color: surfaceColor,
      scaffoldKey: scaffoldKey
    );

    return StreamBuilder(
      stream: FirestoreServices.getCart(userId),
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
            body: const ItemIndicator(
              icon: IconlyBroken.buy,
              text: 'Cart is empty',
            ),
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
              icon: IconlyBroken.paper,
              action: () {
                Get.to(() => const ShippingScreen());
              },
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: ListView.builder(
                        clipBehavior: Clip.none,
                        itemCount: data.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: CartProductCard(
                              id: data[index].id,
                              name: data[index]['name'],
                              category: data[index]['category'],
                              imageUrl: data[index]['imageUrl'],
                              price: data[index]['price'],
                              quantity: data[index]['quantity'],
                            ),
                          );
                        }
                      ),
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
