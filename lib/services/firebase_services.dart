import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfresh/consts/firebase_consts.dart';

class FirestoreServices {
  // Home: Get users by role
  static getUsersByRole(role) {
    return firestore.collection(usersCollection)
    .where('role', isEqualTo: role)
    .get();
  }

  // Home: Get a list of appoitments
  static getAppointments(userId, status) {
    return firestore.collection(appointmentsCollection)
    .where('status', isEqualTo: status)
    .where('docId', isEqualTo: userId)
    .get();
  }

  // Appointment Details: Get appointment details
  static getAppointment(appointmentId) {
    return firestore.collection(appointmentsCollection)
    .doc(appointmentId)
    .get();
  }

  // Patient History: Get a list of appoitments from patient
  static getPatientAppointments(userId) {
    return firestore.collection(appointmentsCollection)
    .where('patientId', isEqualTo: userId)
    .get();
  }

  // Patient History: Get doctor's name
  static getDoctorName(docId) {
    return firestore.collection(usersCollection)
    .doc(docId)
    .get();
  }

  // User Profile: Get specific user's information 
  static getTargetUser(userId) {
    return firestore.collection(usersCollection)
    .doc(userId)
    .get();
  }

  // Edit Profile: Get user's details
  static getUser(userId) {
    return firestore.collection(usersCollection)
    .doc(userId)
    .get();
  }

  // Notifications: Get user notifications
  static getNotifications(userId) {
    return firestore.collection(usersCollection)
    .doc(userId)
    .collection(notificationsCollection)
    .orderBy('date', descending: true)
    .get();
  }

  // Notifications: Get user notifications
  static removeAllNotifications(userId) async {
    QuerySnapshot notifications = await
    firestore.collection(usersCollection)
    .doc(userId)
    .collection(notificationsCollection)
    .get();

    for (var notif in notifications.docs) {
      firestore.collection(usersCollection)
      .doc(userId)
      .collection(notificationsCollection)
      .doc(notif.id)
      .delete();
    }
  }

  // Notifications: Get unread user notifications
  static getUnreadNotifications(userId) {
    return firestore.collection(usersCollection)
    .doc(userId)
    .collection(notificationsCollection)
    .where('read', isEqualTo: false)
    .snapshots();
  }

  // Store: Retrieve products based on category
  static getProducts(category) {
    return firestore.collection(productsCollection)
    .where('category', isEqualTo: category)
    .snapshots();
  }

  // Cart: Retreive cart items based on user ID
  static getCart(userId) {
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
    return firestore.collection(cartCollection)
    .doc(docId)
    .delete();
  }

  // Search: Search products
  static searchProducts() {
    return firestore.collection(productsCollection).get();
  }

  // Orders: Retrieve orders based on user ID and category
  static getOrdersByStatus(userId, status) {
    if (status != '') {
      return firestore.collection(ordersCollection)
      .where('userId', isEqualTo: userId)
      .where('order_status', isEqualTo: status)
      .orderBy('order_date', descending: true)
      .snapshots();
    }
    else {
      return firestore.collection(ordersCollection)
      .where('userId', isEqualTo: userId)
      .orderBy('order_date', descending: true)
      .snapshots();
    }
  }

  // Orders: Retrieve order item data
  static getOrderData(orderId) {
    return firestore.collection(ordersCollection)
    .doc(orderId)
    .get();
  }

  // Orders: Cancel the order
  static cancelOrder(orderId) async {
    var quantity = firestore.collection(ordersCollection).doc(orderId);
    await quantity.set({
      'order_status': 'cancelled',
    }, SetOptions(merge: true));
  }
}