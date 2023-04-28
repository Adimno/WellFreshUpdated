import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/services/firebase_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: CustomAppBar(title: 'My Orders', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: accentTextColor,
            unselectedLabelColor: primaryTextColor,
            indicatorColor: accentColor,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All Orders'),
              Tab(text: 'Pending'),
              Tab(text: 'Received'),
              Tab(text: 'Cancelled'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OrdersByStatus(stream: FirestoreServices.getOrdersByStatus(userId, '')),
                OrdersByStatus(stream: FirestoreServices.getOrdersByStatus(userId, 'pending')),
                OrdersByStatus(stream: FirestoreServices.getOrdersByStatus(userId, 'received')),
                OrdersByStatus(stream: FirestoreServices.getOrdersByStatus(userId, 'cancelled')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersByStatus extends StatelessWidget {
  final dynamic stream;

  const OrdersByStatus({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.data!.docs.isEmpty) {
          return const ItemIndicator(icon: IconlyBroken.bag, text: 'You have no orders');
        }
        else {
          var data = snapshot.data!.docs;
                  
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: OrderCard(
                      orderId: data[index].id,
                      totalItems: data[index]['products'].length,
                      totalAmount: data[index]['total'],
                      orderDate: data[index]['order_date'],
                      orderStatus: data[index]['order_status'],
                    ),
                  );
                }
              ),
            ),
          );
        }
      }
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final int totalItems;
  final int totalAmount;
  final Timestamp orderDate;
  final String orderStatus;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.totalItems,
    required this.totalAmount,
    required this.orderDate,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat('#,###.00');
    var date = DateFormat.yMMMd().add_jm();

    return Container(
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [containerShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: orderId),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: orderStatus == 'pending' ? warningColor
                    : orderStatus == 'received' ? accentColor
                    : errorColor,
                  foregroundColor: orderStatus != 'pending' ? invertTextColor : primaryTextColor,
                  radius: 24,
                  child: Icon(orderStatus == 'pending' ? IconlyLight.timeCircle
                    : orderStatus == 'received' ? IconlyLight.bag
                    : IconlyLight.dangerCircle),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Placed on ${date.format(orderDate.toDate())}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: tertiaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Order ID: ${orderId.substring(0, 7)}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      totalItems == 1 ? '$totalItems item' : '$totalItems items',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: tertiaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'PHP ${currency.format(totalAmount)}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: accentTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  IconlyBroken.arrowRight2,
                  color: tertiaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}