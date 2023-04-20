import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/controllers/product_controller.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';

class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> product;
  final double widthFactor;
  final bool enableHero;

  const ProductCard({
    Key? key,
    required this.product,
    required this.widthFactor,
    this.enableHero = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return Container(
      width: MediaQuery.of(context).size.width / widthFactor,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [containerShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(() => ProductScreen(
              title: product['name'],
              data: product,
              hero: product.id
            ));
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              backgroundColor: surfaceColor,
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        CustomListTile(
                          icon: IconlyBroken.buy,
                          text: 'Add to Cart',
                          action: () {
                            controller.addToCart(
                              name: product['name'],
                              category: product['category'],
                              imageUrl: product['imageUrl'],
                              price: product['price'],
                              context: context,
                            );
                            Navigator.pop(context);
                            FloatingSnackBar.show(context, 'Item added successfully!');
                          },
                        ),
                        CustomListTile(
                          icon: IconlyBroken.document,
                          text: 'View product details',
                          action: () {
                            Navigator.pop(context);
                            Get.to(() => ProductScreen(
                              title: product['name'],
                              data: product,
                              hero: product.id
                            ));
                          },
                        ),
                        CustomListTile(
                          icon: IconlyBroken.search,
                          text: 'Search similar products',
                          action: () {
                            Navigator.pop(context);
                            Get.to(() => SearchScreen(title: product['name']));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: enableHero ? Hero(
                      tag: 'productImage${product.id}',
                      child: Image.network(
                        product['imageUrl'],
                      ),
                    ) : Image.network(
                      product['imageUrl'],
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            'PHP ${product['price']}',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: secondaryTextColor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}