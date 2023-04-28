import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wellfresh/controllers/cart_controller.dart';
import 'package:wellfresh/theme.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var currency = NumberFormat('#,###.00');

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [containerShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                          Theme.of(context).textTheme.titleSmall!.copyWith(color: secondaryTextColor),
                    ),
                    Obx(() =>
                      Text(
                        'PHP ${currency.format(controller.total.value)}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: secondaryTextColor),
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
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: secondaryTextColor),
                    ),
                    Text(
                      'PHP 50.00',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: secondaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: secondaryTextColor),
                    ),
                    Obx(() =>
                      Text(
                        'PHP ${currency.format(controller.total.value + controller.shippingFee)}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: secondaryTextColor),
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
