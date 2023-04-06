import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: CustomAppBar(title: 'Payment Methods', backButton: true, scaffoldKey: scaffoldKey),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0.0,
        child: Obx(() =>
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
            child: controller.placingOrder.value ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(
              onPressed: () async {
                if (paymentMethods[controller.paymentIndex.value]['name'] == 'PayPal') {
                  // TODO: Put dummy PayPal here

                  const orderPlaced = SnackBar(
                    content: Text('You got PayPal!'),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(orderPlaced);
                  Get.offAll(const StoreScreen());
                }
                else if (paymentMethods[controller.paymentIndex.value]['name'] == 'Cash') {
                  await controller.placeMyOrder(
                    orderPaymentMethod: paymentMethods[controller.paymentIndex.value]['name'],
                    total: controller.total.value,
                  );
                  await controller.clearCart();
                  const orderPlaced = SnackBar(
                    content: Text('Your order has been successfully placed!'),
                    behavior: SnackBarBehavior.floating,
                  );
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(orderPlaced);
                  Get.offAll(const StoreScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Place Order',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Choose your payment option',
              style: Theme.of(context).textTheme.bodyLarge,
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
                          color: controller.paymentIndex.value == index ? const Color(0xFF51A8FF)  : Colors.white,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: controller.paymentIndex.value == index ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                paymentMethods[index]['description'],
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: controller.paymentIndex.value == index ? Colors.white : Colors.black,
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
            const OrderSummary(),
          ],
        ),
      ),
    );
  }
}