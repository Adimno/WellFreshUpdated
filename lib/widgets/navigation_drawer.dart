import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/doctorSchedule.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/consts/consts.dart';

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
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: () => openScreen(context, const WidgetTest()),
                      child: const Image(
                        image: AssetImage('assets/logo/logowork.png'),
                        width: 72,
                        height: 72,
                        alignment: Alignment.centerLeft,
                      ),
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
                            text: role == 'patient' ? 'Appointment' : 'Doctor Appointments',
                            action: () => openScreen(context,
                              role == 'patient' ? null /* TODO: For Appointment */ : null /* TODO: For doctor appointments */
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
                              action: () => openScreen(context, DoctorSchedule(docId: FirebaseAuth.instance.currentUser!.uid)),
                            ),
                            const SizedBox(height: 10),
                          ],
                          CustomListTile(
                            icon: IconlyBroken.call,
                            text: 'Contact us',
                            // TODO: For contact us page
                            action: () => openScreen(context, null),
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
                            CircleAvatar(
                              backgroundColor: tertiaryColor,
                              radius: 24,
                              backgroundImage: NetworkImage(
                                data['imageUrl'] ?? defAvatar
                              ),
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
              return FloatingSnackBar.show(context, 'Error loading items');
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