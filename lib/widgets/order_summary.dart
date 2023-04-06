import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellfreshlogin/controllers/cart_controller.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Column(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style:
                          Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0xff5e6177)),
                    ),
                    Obx(() =>
                      Text(
                        'PHP ${controller.total.value}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: const Color(0xff5e6177)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping Fee',
                      style:
                          Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0xff5e6177)),
                    ),
                    Text(
                      'PHP 50',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: const Color(0xff5e6177)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: const Color(0xff5e6177)),
                    ),
                    Obx(() =>
                      Text(
                        'PHP ${controller.total.value + controller.shippingFee}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: const Color(0xff5e6177)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
