import 'package:get/get.dart';
import 'package:wellfreshlogin/consts/consts.dart';

class ProductController extends GetxController {
  addToCart({
    name,
    category,
    imageUrl,
    price,
    userId,
    context,
  }) async {
    await firestore.collection(cartCollection).doc().set({
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'userId': userId,
      'quantity': 1,
    }).catchError((error) { });
  }
}