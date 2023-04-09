import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/controllers/home_controller.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Dental Store', backButton: false, color: surfaceColor, scaffoldKey: scaffoldKey),
      drawer: const NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: CustomTextField(
                hintText: 'Search products',
                prefixIcon: const Icon(
                  IconlyBroken.search,
                  color: secondaryTextColor,
                ),
                suffixIcon: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: IconButton(
                    icon: const Icon(IconlyBroken.arrowRight2),
                    color: Colors.white,
                    onPressed: () {
                      if (controller.searchController.text.isNotEmpty) {
                        Get.to(() => SearchScreen(title: controller.searchController.text));
                      }
                    },
                  ),
                ),
                controller: controller.searchController
              ),
            ),
            const SectionTitle(title: 'Dental Floss'),
            const ProductCarousel(category: 'Dental Floss'),
            const SectionTitle(title: 'Toothbrush'),
            const ProductCarousel(category: 'Toothbrush'),
            const SectionTitle(title: 'Toothpaste'),
            const ProductCarousel(category: 'Toothpaste'),
          ],
        ),
      ),
      floatingActionButton: FittedBox(
        child: Stack(
          alignment: const Alignment(1.4, -1.5),
          children: [
            FloatingActionButton(  // Your actual Fab
              onPressed: () {
                Get.to(() => const CartScreen());
              },
              backgroundColor: accentColor,
              child: const Icon(IconlyBroken.buy),
            ),
            StreamBuilder(
              // TODO: Change 1 to the logged user's ID
              stream: FirestoreServices.getCart(1),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container();
                }
                else {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(minHeight: 28, minWidth: 28),
                    decoration: BoxDecoration(
                      boxShadow: const [containerShadow],
                      borderRadius: BorderRadius.circular(16),
                      color: errorColor,
                    ),
                    child: Center(
                      child: Text(
                        snapshot.data!.docs.length.toString(),
                        style: const TextStyle(color: Colors.white)
                      ),
                    ),
                  );
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}
