import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
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
            const formIncom = SnackBar(
              content: Text('Please complete the form!'),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(formIncom);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Please fill out your shipping and delivery information.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                title: 'Address',
                hint: 'Address',
                icon: Icons.home_outlined,
                controller: controller.addressController
              ),
              CustomTextField(
                title: 'City',
                hint: 'City',
                icon: Icons.location_city_outlined,
                controller: controller.cityController
              ),
              CustomTextField(
                title: 'State',
                hint: 'State',
                icon: Icons.public_outlined,
                controller: controller.stateController
              ),
              CustomTextField(
                title: 'ZIP Code',
                hint: 'ZIP Code',
                icon: Icons.note_outlined,
                controller: controller.zipCodeController
              ),
            ]
          ),
        ),
      ),
    );
  }
}