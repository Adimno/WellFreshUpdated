import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCarousel extends StatelessWidget {
  final String category;

  const ProductCarousel({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 220,
        child: StreamBuilder(
          stream: FirestoreServices.getProducts(category),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.data!.docs.isEmpty) {
              return const ItemIndicator(
                icon: IconlyBroken.category,
                text: 'No products found',
              );
            }
            else {
              var data = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ProductCard(
                      product: data[index],
                      widthFactor: 3,
                      enableHero: true,
                    ),
                  );
                }
              );
            }
          }
        ),
      ),
    );
  }
}