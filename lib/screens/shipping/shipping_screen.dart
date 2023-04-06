import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/controllers/cart_controller.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Shipping Info', backButton: true, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Proceed to Payment',
        icon: const Icon(IconlyBroken.wallet),
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
        child: Padding(
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
                hint: 'Address',
                icon: IconlyBroken.home,
                controller: controller.addressController
              ),
              CustomTextField(
                title: 'City',
                hint: 'City',
                icon: IconlyBroken.location,
                controller: controller.cityController
              ),
              CustomTextField(
                title: 'State',
                hint: 'State',
                icon: IconlyBroken.location,
                controller: controller.stateController
              ),
              CustomTextField(
                title: 'ZIP Code',
                hint: 'ZIP Code',
                icon: IconlyBroken.location,
                controller: controller.zipCodeController
              ),
            ]
          ),
        ),
      ),
    );
  }
}