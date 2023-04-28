import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/consts/firebase_consts.dart';
import 'package:wellfresh/controllers/cart_controller.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  var controller = Get.find<CartController>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var user = FirebaseFirestore.instance.collection(usersCollection);

  void getDeliveryDetails() async {
    DocumentSnapshot snapshot = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        if (data['delivery_details'][0]) {
          controller.addressController.text = data['delivery_details'][1];
          controller.cityController.text = data['delivery_details'][2];
          controller.stateController.text = data['delivery_details'][3];
          controller.zipCodeController.text = data['delivery_details'][4];
        }
      });
    }
  }

  @override
  void initState() {
    getDeliveryDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Shipping Info', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Proceed to Payment',
        icon: IconlyBroken.wallet,
        action: () {
          if (
            controller.addressController.text.isNotEmpty &&
            controller.cityController.text.isNotEmpty &&
            controller.stateController.text.isNotEmpty &&
            controller.zipCodeController.text.isNotEmpty
          ) {
            Get.to(() => const PaymentMethods());
          }
          else {
            FloatingSnackBar.show(context, 'Please complete the form!');
          }
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Please fill out your shipping and delivery information.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: tertiaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                title: 'Address',
                hintText: 'Address',
                prefixIcon: const Icon(IconlyBroken.home, color: tertiaryTextColor),
                controller: controller.addressController,
              ),
              CustomTextField(
                title: 'City',
                hintText: 'City',
                prefixIcon: const Icon(IconlyBroken.location, color: tertiaryTextColor),
                controller: controller.cityController,
              ),
              CustomTextField(
                title: 'State',
                hintText: 'State',
                prefixIcon: const Icon(IconlyBroken.location, color: tertiaryTextColor),
                controller: controller.stateController,
              ),
              CustomTextField(
                title: 'ZIP Code',
                hintText: 'ZIP Code',
                prefixIcon: const Icon(IconlyBroken.location, color: tertiaryTextColor),
                controller: controller.zipCodeController,
              ),
            ]
          ),
        ),
      ),
    );
  }
}