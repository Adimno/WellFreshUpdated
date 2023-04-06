import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:wellfreshlogin/theme.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({
    Key? key,
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  final dynamic id;
  final String name;
  final String category;
  final String imageUrl;
  final int price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [containerShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'PHP $price',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: accentTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [containerShadow],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(IconlyBroken.arrowLeft2),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          FirestoreServices.removeItemQuantity(id, quantity);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [containerShadow],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(IconlyBroken.arrowRight2),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          FirestoreServices.addItemQuantity(id, quantity);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
