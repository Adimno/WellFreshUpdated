import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/consts/firebase_consts.dart';

class FirestoreServices {
  // Home: Retrieve products based on category
  static getProducts(category) {
    return firestore.collection(productsCollection)
    .where('category', isEqualTo: category)
    .snapshots();
  }

  // Cart: Retreive cart items based on user ID
  static getCart() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return firestore.collection(cartCollection)
    .where('userId', isEqualTo: userId)
    .snapshots();
  }

  // Cart: Add quantity
  static addItemQuantity(itemId, qty) async {
    qty = qty + 1;
    var quantity = firestore.collection(cartCollection).doc(itemId);
    await quantity.set({
      'quantity': qty,
    }, SetOptions(merge: true));
  }

  // Cart: Remove quantity
  static removeItemQuantity(itemId, qty) async {
    qty = qty - 1;

    if (qty == 0) {
      deleteCartItem(itemId);
    }
    else {
      var quantity = firestore.collection(cartCollection).doc(itemId);
      await quantity.set({
        'quantity': qty,
      }, SetOptions(merge: true));
    }
  }

  // Cart: Remove item from cart
  static deleteCartItem(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  // Search: Search products
  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }
}