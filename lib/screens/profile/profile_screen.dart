import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/doctorSchedule.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Profile', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(usersCollection)
            .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data() as Map<String, dynamic>;
              
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(99)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ImageScreen(
                            imageUrl: data['imageUrl'] ?? defAvatar,
                            altText: '${data['firstname']} ${data['lastname']}',
                            hero: 'profile',
                          );
                        }));
                      },
                      child: Hero(
                        tag: 'profile',
                        child: CircleAvatar(
                          backgroundColor: tertiaryColor,
                          backgroundImage: NetworkImage(data['imageUrl'] ?? defAvatar),
                          radius: 90,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${data['firstname'] ?? ''} ${data['lastname'] ?? ''}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['email'] ?? '',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: tertiaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(IconlyBroken.location, color: tertiaryTextColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          data.containsKey('delivery_details') ? data['delivery_details'][2] : 'N/A',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: tertiaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(IconlyBroken.call, color: tertiaryTextColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          data['phoneNumber'] ?? 'N/A',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: tertiaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (!data.containsKey('gender') && !data.containsKey('address')) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ));
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [containerShadow],
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: cardColor,
                                foregroundColor: accentColor,
                                child: Icon(
                                  IconlyBroken.profile,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Few more steps...',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        color: invertTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Complete your details by editing your profile.',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: fadeTextColor,
                                        height: 1.25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                IconlyBroken.arrowRight2,
                                color: fadeTextColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [containerShadow],
                      ),
                      child: Column(
                        children: [
                          CustomListTile(
                            icon: IconlyBroken.editSquare,
                            text: 'Edit Profile',
                            dense: true,
                            action: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ));
                            },
                          ),
                          const Divider(color: borderColor),
                          if (data['role'].toLowerCase() == 'patient') ...[
                            CustomListTile(
                              icon: IconlyBroken.paper,
                              text: 'My Delivery Details',
                              dense: true,
                              action: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const DeliveryDetailsScreen(),
                                ));
                              },
                            ),
                            const Divider(color: borderColor),
                          ],
                          CustomListTile(
                            icon: IconlyBroken.calendar,
                            text: 'My Appointments',
                            dense: true,
                            action: () {
                              // TODO: For Appointments
                            },
                          ),
                          const Divider(color: borderColor),
                          if (data['role'].toLowerCase() == 'doctor') ...[
                            CustomListTile(
                              icon: IconlyBroken.timeCircle,
                              text: 'My Schedules',
                              dense: true,
                              action: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DoctorSchedule(docId: FirebaseAuth.instance.currentUser!.uid),
                                ));
                              },
                            ),
                            const Divider(color: borderColor),
                          ],
                          if (data['role'].toLowerCase() == 'patient') ...[
                            CustomListTile(
                              icon: IconlyBroken.bag,
                              text: 'My Orders',
                              dense: true,
                              action: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const OrdersScreen(),
                                ));
                              },
                            ),
                            const Divider(color: borderColor),
                          ],
                          CustomListTile(
                            icon: IconlyBroken.logout,
                            text: 'Logout',
                            dense: true,
                            action: () async {
                              await FirebaseAuth.instance.signOut();
                              // ignore: use_build_context_synchronously
                              FloatingSnackBar.show(context, 'You are now logged out. See you soon');
                              Get.offAll(() => const LoginScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
