import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/consts/consts.dart';
import 'package:wellfresh/controllers/cart_controller.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: null,
      appBar: CustomAppBar(title: 'Payment Methods', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Obx(() =>
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
            child: controller.placingOrder.value ? const Center(
              child: CircularProgressIndicator(),
            ) : ActionButton(
              icon: IconlyBroken.bag2,
              title: 'Place order',
              backgroundColor: accentColor,
              action: () async {
                await controller.placeMyOrder(
                  orderPaymentMethod: paymentMethods[controller.paymentIndex.value]['name'],
                  total: controller.total.value,
                );
                await controller.clearCart();
                Future.delayed(Duration.zero).then((value) => {
                  FloatingSnackBar.show(context, 'Your order has been placed successfully!'),
                  Get.offAll(() => const StoreScreen())
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your payment option',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: tertiaryTextColor,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.changePaymentIndex(index);
                              },
                              child: Obx(() =>
                                Container(
                                  width: 128,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: controller.paymentIndex.value == index ? accentColor : cardColor,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: const [containerShadow],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          paymentMethods[index]['image'],
                                          width: 48,
                                          height: 48,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          paymentMethods[index]['name'],
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: controller.paymentIndex.value == index ? Colors.white : primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          paymentMethods[index]['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: controller.paymentIndex.value == index ? Colors.white : tertiaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                var cartController = Get.find<CartController>();
                                var total = cartController.total;
                                var currency = 'PHP'; // replace with your desired currency code

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => UsePaypal(
                                      sandboxMode: true,
                                      clientId: 'AYoOOEvdhqHgN2oHVvoKN8dvb_Y5UuoQ1t6SUeNLTkDSngBxabr0-P7Qfp2keDgOkMK7KE1HfRe0jzqm',
                                      secretKey: 'EIrBVul0JKgOi-MK6EOPAAwX-IFlrLzkMwhm8uk8ZsH7HaTpM1VetLPlqBncyMaBv7lab33i7OA9CSPa',
                                      returnURL: 'https://samplesite.com/return',
                                      cancelURL: 'https://samplesite.com/cancel',
                                      transactions: [
                                        {
                                          'amount': {
                                            'total': total.value + cartController.shippingFee,
                                            'currency': currency,
                                            'details': {
                                              'subtotal': total.value,
                                              'shipping': cartController.shippingFee,
                                            }
                                          },
                                          'description': 'The payment transaction description.',
                                          'item_list': {
                                            'items': cartController.products.map((product) {
                                              return {
                                                'name': product['name'],
                                                'quantity': product['quantity'],
                                                'price': product['price'],
                                                'currency': currency,
                                              };
                                            }).toList(),
                                          },
                                          'shipping_address': {
                                            'line1': controller.addressController.text,
                                            'city': controller.cityController.text,
                                            'state': controller.stateController.text,
                                            'postal_code': controller.zipCodeController.text,
                                            'country_code': 'PH'
                                          }
                                        }
                                      ],
                                      note: 'Contact us for any questions on your order.',
                                      onSuccess: (Map params) async {
                                        Get.find<CartController>().clearCart();
                                        await Get.defaultDialog(
                                          title: 'Payment Successful',
                                          middleText: 'Thank you for your purchase!',
                                          textConfirm: 'OK',

                                          onConfirm: () async {
                                            List<Map<String, dynamic>> products = [];
                                            for (var product in controller.productSnapshot) {
                                              Map<String, dynamic> productMap = {
                                                'category': product['category'],
                                                'imageUrl': product['imageUrl'],
                                                'name': product['name'],
                                                'price': product['price'],
                                                'quantity': product['quantity'],
                                              };
                                              products.add(productMap);
                                            }
                                            // Get the address details entered by the user
                                            final address = controller.addressController.text;
                                            final city = controller.cityController.text;
                                            final state = controller.stateController.text;
                                            final zipCode = controller.zipCodeController.text;
                                            String initialStatus = 'pending';

                                            // Save the order details to Firestore
                                            await FirebaseFirestore.instance.collection('orders').add({
                                              'userId': FirebaseAuth.instance.currentUser!.uid,
                                              'total': total.value + cartController.shippingFee,
                                              'address': address,
                                              'city': city,
                                              'state': state,
                                              'zip_code': zipCode,
                                              'products': products,
                                              'payment_method': 'Paypal',
                                              'order_status': initialStatus,
                                              'order_date': DateTime.now(),
                                            });
                                            Get.offAll(() => const HomeScreen());
                                          },
                                        );
                                      },
                                      onError: () {},
                                      onCancel: () {},
                                    ),
                                  ),
                                );
                              },
                              child: Obx(() =>
                                Container(
                                  width: 128,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: controller.paymentIndex.value == index ? accentColor : cardColor,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: const [containerShadow],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/payments/paypal.png',
                                          width: 70,
                                          height: 50,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Paypal',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: controller.paymentIndex.value == index ? Colors.white : primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Pay with paypal',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: controller.paymentIndex.value == index ? Colors.white : tertiaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const OrderSummary(),
          ],
        ),
      ),
    );
  }
}