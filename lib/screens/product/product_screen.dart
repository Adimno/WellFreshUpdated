import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/controllers/product_controller.dart';

class ProductScreen extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ProductScreen({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Product Details', backButton: true, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Add to Cart',
        icon: const Icon(IconlyBroken.buy),
        action: () {
          controller.addToCart(
            name: data['name'],
            category: data['category'],
            imageUrl: data['imageUrl'],
            price: data['price'],
            // TODO: Change 1 to the logged user's ID
            userId: 1,
            context: context,
          );
          const itemAdded = SnackBar(
            content: Text('Item successfully added to cart!'),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(itemAdded);
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.network(
                    data['imageUrl'],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data['name'],
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  'PHP ${data['price']}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: const Color(0xff51a8ff),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data['description'],
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color.fromRGBO(8, 12, 47, .65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
