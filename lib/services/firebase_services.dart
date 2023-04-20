import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/consts/firebase_consts.dart';

class FirestoreServices {
  // Home: Get users by role
  static getUsersByRole(role) {
    return firestore.collection(usersCollection)
    .where('role', isEqualTo: role)
    .get();
  }

  // Home (Doctor): Get a list of appoitments
  static getAppointments(status) {
    return firestore.collection(usersCollection)
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('appointments')
    .where('status', isEqualTo: status)
    .get();
  }

  // User Profile: Get specific user's information 
  static getTargetUser(userId) {
    return firestore.collection(usersCollection)
    .doc(userId)
    .get();
  }

  // Edit Profile: Get user's details
  static getUser() {
    return firestore.collection(usersCollection)
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();
  }

  // Store: Retrieve products based on category
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
  static searchProducts() {
    return firestore.collection(productsCollection).get();
  }

  // Orders: Retrieve orders based on user ID and category
  static getOrdersByStatus(status) {
    if (status != '') {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      return firestore.collection(ordersCollection)
      .where('userId', isEqualTo: userId)
      .where('order_status', isEqualTo: status)
      .orderBy('order_date', descending: true)
      .snapshots();
    }
    else {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      return firestore.collection(ordersCollection)
      .where('userId', isEqualTo: userId)
      .orderBy('order_date', descending: true)
      .snapshots();
    }
  }

  // Orders: Retrieve order item data
  static getOrderData(orderId) {
    return firestore.collection(ordersCollection).doc(orderId).get();
  }

  // Orders: Cancel the order
  static cancelOrder(orderId) async {
    var quantity = firestore.collection(ordersCollection).doc(orderId);
    await quantity.set({
      'order_status': 'cancelled',
    }, SetOptions(merge: true));
  }
}