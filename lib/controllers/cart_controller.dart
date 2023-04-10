import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/consts/firebase_consts.dart';

class CartController extends GetxController {
  var total = 0.obs;
  var shippingFee = 50;

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var zipCodeController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];

  var placingOrder = false.obs;

  calculate(data) {
    total.value = 0;
    for (var i = 0; i < data.length; i++) {
      total.value = total.value + (int.parse(data[i]['price'].toString()) * int.parse(data[i]['quantity'].toString()));
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({
    required orderPaymentMethod,
    required total
  }) async {
    placingOrder(true);
    await getProductDetails();

    String userId = FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection(ordersCollection).doc().set({
      'order_date': FieldValue.serverTimestamp(),
      'userId': userId,
      'address': addressController.text,
      'state': stateController.text,
      'city': cityController.text,
      'zip_code': zipCodeController.text,
      'payment_method': orderPaymentMethod,
      'total': total,
      'products': FieldValue.arrayUnion(products),
      'order_status': 'pending',
    });
    placingOrder(false);
  }

  getProductDetails() {
    products.clear();

    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'name': productSnapshot[i]['name'],
        'category': productSnapshot[i]['category'],
        'imageUrl': productSnapshot[i]['imageUrl'],
        'price': productSnapshot[i]['price'],
        'quantity': productSnapshot[i]['quantity'],
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}