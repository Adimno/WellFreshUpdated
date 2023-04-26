import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var currency = NumberFormat('#,###.00');
    var date = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: CustomAppBar(title: 'Order Details', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirestoreServices.getOrderData(orderId),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              else {
                var data = snapshot.data!.data();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: data!['order_status'] == 'pending' ? warningColor
                          : data['order_status'] == 'received' ? accentColor
                          : errorColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [containerShadow],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: cardColor,
                            foregroundColor: data['order_status'] == 'pending' ? primaryTextColor
                              : data['order_status'] == 'received' ? accentColor
                              : errorColor,
                            radius: 24,
                            child: Icon(
                              data['order_status'] == 'pending' ? IconlyBroken.timeCircle
                              : data['order_status'] == 'received' ? IconlyLight.bag
                              : IconlyLight.dangerCircle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['order_status'] == 'pending' ? 'Pending'
                                  : data['order_status'] == 'received' ? 'Received'
                                  : 'Cancelled',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: data['order_status'] != 'pending' ? invertTextColor : primaryTextColor,
                                  ),
                                ),
                                Text(
                                  data['order_status'] == 'pending' ? 'Your order is currently being processed for packaging and delivery.'
                                  : data['order_status'] == 'received' ? 'Your order is complete and has been locked.'
                                  : 'Cancelled by user.',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    height: 1.25,
                                    color: data['order_status'] != 'pending' ? invertTextColor : primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Items ordered (${data['products'].length})',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [containerShadow],
                      ),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: data['products'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Image.network(
                                  data['products'][index]['imageUrl'],
                                  width: 48,
                                  height: 48,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['products'][index]['name'],
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      data['products'][index]['category'],
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: tertiaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      'PHP ${data['products'][index]['price'].toString()}',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: accentTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  'Qty: ${data['products'][index]['quantity'].toString()}',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: tertiaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(color: borderColor),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [containerShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order details',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          TextTableRow(startText: 'Order ID', endText: orderId),
                          TextTableRow(startText: 'Date placed', endText: date.format(data['order_date'].toDate())),
                          TextTableRow(startText: 'Paid by', endText: data['payment_method']),
                          TextTableRow(startText: 'Order status', endText: data['order_status']),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(color: borderColor),
                          ),
                          Text(
                            'Delivery Information',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          TextTableRow(startText: 'Address', endText: data['address']),
                          TextTableRow(startText: 'City', endText: data['city']),
                          TextTableRow(startText: 'State', endText: data['state']),
                          TextTableRow(startText: 'ZIP Code', endText: data['zip_code']),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [containerShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment information',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          TextTableRow(startText: 'Subtotal', endText: 'PHP ${currency.format(data['total'] - 50)}'),
                          TextTableRow(startText: 'Shipping fee', endText: 'PHP ${currency.format(50)}'),
                          TextTableRow(startText: 'Total', endText: 'PHP ${currency.format(data['total'])}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: ActionButton(
                        title: 'Cancel order',
                        backgroundColor: accentColor,
                        action: data['order_status'] == 'pending' ?
                        () {
                          showCancelDialog(context, orderId);
                        }
                        : null,
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TextTableRow extends StatelessWidget {
  final String startText;
  final String endText;

  const TextTableRow({
    super.key,
    required this.startText,
    required this.endText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            startText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: tertiaryTextColor,
            ),
          ),
          Text(
            endText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: tertiaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

showCancelDialog(BuildContext context, orderId) {
  AlertDialog alert = AlertDialog(
    backgroundColor: surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24))
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    title: Text(
      'Confirm action',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: secondaryTextColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Are you sure you want to cancel this order? You will have to order these items again if you change your mind.',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ActionButton(
              title: 'Cancel',
              backgroundColor: cardColor,
              foregroundColor: accentTextColor,
              action: () => Navigator.pop(context),
            ),
            ActionButton(
              title: 'Cancel order',
              backgroundColor: errorColor,
              foregroundColor: invertTextColor,
              action: () {
                FirestoreServices.cancelOrder(orderId);
                Navigator.pop(context);
                Navigator.pop(context);
                FloatingSnackBar.show(context, 'Your order has been cancelled');
              },
            ),
          ],
        ),
      ],
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAppointmentDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: surfaceColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24))
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    title: Text(
      'Important Reminder',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: secondaryTextColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Failure to go to your appointment will incur a charge of 500 pesos. This is due to the high volume of patients who want to settle an appointment. This fee shall be collected on your next visit in our clinic.',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ActionButton(
              title: 'Cancel',
              backgroundColor: cardColor,
              foregroundColor: accentTextColor,
              action: () => Navigator.pop(context),
            ),
            ActionButton(
              title: 'Confirm',
              backgroundColor: accentColor,
              foregroundColor: invertTextColor,
              action: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}