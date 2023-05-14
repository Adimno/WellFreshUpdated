import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/consts/consts.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        color: surfaceColor,
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection(usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              var role = data['role'].toLowerCase() ?? 'patient';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Image(
                      image: AssetImage('assets/logo/logowork.png'),
                      width: 72,
                      height: 72,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomListTile(
                            icon: IconlyBroken.home,
                            text: 'Home',
                            action: () => openScreen(context, const HomeScreen()),
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            icon: IconlyBroken.calendar,
                            text: 'My Appointments',
                            action: () => openScreen(context,
                              role == 'patient' ? const AppointmentsScreen() : const PatientListScreen(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (role == 'patient') ...[
                            CustomListTile(
                              icon: IconlyBroken.bag,
                              text: 'Dental Store',
                              action: () => openScreen(context, const StoreScreen()),
                            ),
                            const SizedBox(height: 10),
                          ] else ... [
                            CustomListTile(
                              icon: IconlyBroken.timeCircle,
                              text: 'My Schedules',
                              action: () => openScreen(context, ScheduleScreen(docId: FirebaseAuth.instance.currentUser!.uid)),
                            ),
                            const SizedBox(height: 10),
                          ],
                          CustomListTile(
                            icon: IconlyBroken.call,
                            text: 'Contact us',
                            action: () => openScreen(context, const ContactUsScreen()),
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            icon: IconlyBroken.infoSquare,
                            text: 'About',
                            action: () => openScreen(context, AboutScreen()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        openScreen(context, const ProfileScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: tertiaryColor,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: data.containsKey('imageUrl') ?
                              Image.network(data['imageUrl'], fit: BoxFit.cover)
                              : Image.asset(defAvatar, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['firstname']} ${data['lastname']}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        IconlyBold.profile,
                                        size: 16,
                                        color: tertiaryTextColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        data['role'],
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: tertiaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(IconlyLight.arrowRight2, color: tertiaryTextColor)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
            else if (snapshot.hasError) {
              return const ItemIndicator(icon: IconlyBroken.danger, text: 'Error loading items');
            }
            else {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Opens a new screen
  void openScreen(context, screen) {
    if (screen != null) {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => screen,
      ));
    }
  }
}