import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/controllers/cart_controller.dart';

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
              color: accentColor,
              action: () async {
                if (paymentMethods[controller.paymentIndex.value]['name'] == 'PayPal') {
                  // TODO: Put dummy PayPal here
                  // When making changes to this screen, make sure to go back to the
                  // shipping screen, save, and go back, as it will crash the application!

                  FloatingSnackBar.show(context, 'You got PayPal!');
                  Get.offAll(const StoreScreen());
                }
                else if (paymentMethods[controller.paymentIndex.value]['name'] == 'Cash') {
                  await controller.placeMyOrder(
                    orderPaymentMethod: paymentMethods[controller.paymentIndex.value]['name'],
                    total: controller.total.value,
                  );
                  await controller.clearCart();
                  // ignore: use_build_context_synchronously
                  FloatingSnackBar.show(context, 'You got PayPal!');
                  Get.offAll(const StoreScreen());
                }
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