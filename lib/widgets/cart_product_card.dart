import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

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
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(178, 178, 178, .2),
            blurRadius: 30,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
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
                          color: const Color(0xff51a8ff),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xff5e6177),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(178, 178, 178, .2),
                        blurRadius: 30,
                        offset: Offset(0, 5),
                      ),
                    ],
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(178, 178, 178, .2),
                        blurRadius: 30,
                        offset: Offset(0, 5),
                      ),
                    ],
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
