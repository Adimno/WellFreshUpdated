import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:wellfreshlogin/widgets/floating_snackbar.dart';

class ProductController extends GetxController {
  addToCart({
    name,
    category,
    imageUrl,
    price,
    context,
  }) async {
    bool itemFound = false;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot checkItem = await firestore.collection(cartCollection).where('userId', isEqualTo: userId).get();
    if (checkItem.docs.isNotEmpty) {
      for (int i = 0; i < checkItem.docs.length; i++) {
        DocumentSnapshot doc = checkItem.docs.elementAt(i);

        // If item is found, add the existing item's quantity instead
        if (doc['name'] == name && doc['category'] == category) {
          FirestoreServices.addItemQuantity(doc.id, doc['quantity']);
          itemFound = true;
          break;
        }
      }
    }
    if (itemFound == false) {
      await firestore.collection(cartCollection).doc().set({
        'name': name,
        'category': category,
        'imageUrl': imageUrl,
        'price': price,
        'userId': userId,
        'quantity': 1,
      }).catchError((error) {
        FloatingSnackBar.show(context, 'There was an error adding item to cart');
      });
    }
  }
}