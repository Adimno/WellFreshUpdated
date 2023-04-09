import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/controllers/product_controller.dart';

class ProductScreen extends StatelessWidget {
  final String? title;
  final dynamic data;
  final dynamic hero;

  const ProductScreen({
    Key? key,
    required this.title,
    required this.data,
    required this.hero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Product Details', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Add to Cart',
        icon: IconlyBroken.buy,
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
          FloatingSnackBar.show(context, 'Item added successfully!');
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    alignment: const Alignment(1, 1),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(48),
                        child: Hero(
                          tag: 'productImage$hero',
                          child: Image.network(
                            data['imageUrl'],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[500],
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return ImageScreen(
                                imageUrl: data['imageUrl'],
                                altText: data['name'],
                                hero: 'productImage$hero',
                              );
                            }));
                          },
                          color: Colors.white,
                          icon: const Icon(IconlyBroken.search),
                          tooltip: 'View full image',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data['name'],
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'PHP ${data['price']}',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: accentTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data['description'],
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: tertiaryTextColor,
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