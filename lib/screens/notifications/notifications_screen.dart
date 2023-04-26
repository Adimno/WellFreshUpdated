import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/consts/firebase_consts.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var user = FirebaseFirestore.instance.collection(usersCollection);

  late Future<QuerySnapshot> notifications;

  @override
  void initState() {
    super.initState();
    notifications = FirestoreServices.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        backButton: true,
        color: surfaceColor,
        scaffoldKey: scaffoldKey,
        endIcon: IconlyBroken.delete,
        endAction: () async {
          await FirestoreServices.removeAllNotifications();
          _pullRefresh();
          
          Future.delayed(Duration.zero).then((value) => {
            FloatingSnackBar.show(context, 'Cleared all notifications'),
          });
        },
      ),
      body: FutureBuilder(
        future: FirestoreServices.getNotifications(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.data!.docs.isEmpty) {
            return const ItemIndicator(icon: IconlyBroken.notification, text: 'You have no notifications');
          }
          else {
            var data = snapshot.data!.docs;
                    
            return RefreshIndicator(
              onRefresh: _pullRefresh,
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: notificationCard(
                          data[index].id,
                          data[index]['type'],
                          data[index]['message'],
                          data[index]['reference'],
                          data[index]['read'],
                          data[index]['date'],
                          (data[index].data() as Map<String,dynamic>).containsKey('data')
                          ? data[index]['data'] : [],
                        ),
                      );
                    }
                  ),
                ),
              ),
            );
          }
        }
      ),
    );
  }

  Widget notificationCard(
    String notificationId,
    String type,
    String message,
    String reference,
    bool read,
    Timestamp date,
    dynamic data,
  ) {
    bool updateRead = true;

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
          onTap: type == 'appointment' ?
          () async {
            readNotification(notificationId, read, true);
            reference != '' ?
            Get.to(() => data.isEmpty ?
              AppointmentDetailsPatientScreen(appointmentId: reference)
              : AppointmentDetailsDoctorScreen(
                patientId: data['patientReference'],
                docId: data['docReference'],
                appointmentId: reference,
              ))
            : FloatingSnackBar.show(context, 'Referenced appointment does not exist');
          }
          : type == 'order' ?
          () async {
            readNotification(notificationId, read, true);
            reference != '' ?
            Get.to(() => OrderDetailsScreen(orderId: reference))
            : FloatingSnackBar.show(context, 'Referenced order ID does not exist');
          }
          : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: type == 'appointment' ? errorColor
                    : type == 'order' ? accentColor
                    : Colors.purple[400],
                  foregroundColor: invertTextColor,
                  radius: 24,
                  child: Icon(type == 'appointment' ? IconlyLight.calendar
                    : type == 'order' ? IconlyLight.bag
                    : IconlyLight.notification),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!read) ...[
                            const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: accentColor,
                              ),
                            ),
                          ],
                          Text(
                            timeago.format(date.toDate()),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: tertiaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  onSelected: (item) => {
                    if (item == 0) {
                      updateRead = !read ? true : false,
                      readNotification(notificationId, read, updateRead),
                    }
                    else if (item == 1) {
                      user.doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection(notificationsCollection)
                      .doc(notificationId)
                      .delete(),
                      _pullRefresh(),
                    }
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: tertiaryTextColor,
                  ),
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: boxShadowColor,
                  elevation: 10,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(
                        !read ? 'Mark as read' : 'Mark as unread',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        'Remove',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: errorTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  readNotification(notificationId, read, status) async {
    if (!read && !status) {
      user.doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(notificationsCollection)
      .doc(notificationId)
      .update({
        'read': true,
      });
    }
    else {
      user.doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(notificationsCollection)
      .doc(notificationId)
      .update({
        'read': status,
      });
    }
    _pullRefresh();
  }

  Future<void> _pullRefresh() async {
    QuerySnapshot getNotifications = await FirestoreServices.getNotifications();
    setState(() {
      notifications = Future.value(getNotifications);
    });
  }
}