import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:wellfreshlogin/navigation_drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: CustomAppBar(title: 'Dental Store', backButton: false, scaffoldKey: scaffoldKey),
      drawer: NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 48,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.only(left: 24.0, right: 8.0, top: 4.0, bottom: 4.0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(178, 178, 178, .2),
                    blurRadius: 30,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller.searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff5e6177),
                  ),
                  hintText: 'Search products',
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    icon: const Icon(IconlyBroken.search),
                    onPressed: () {
                      if (controller.searchController.text.isNotEmpty) {
                        Get.to(() => SearchScreen(title: controller.searchController.text));
                      }
                    },
                  ),
                ),
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
              backgroundColor: const Color(0xFF51A8FF),
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
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 16,
                          color: Colors.black.withAlpha(50)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.red,
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
