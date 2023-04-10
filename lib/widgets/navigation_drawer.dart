import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/consts/firebase_consts.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';

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
          future: FirebaseFirestore.instance.collection(usersCollection).doc(FirebaseAuth.instance.currentUser!.uid).get(),
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
                            action: () => openScreen(context,
                              role == 'patient' ? const Patient() : const Doctor()
                            ),
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
                          ],
                          CustomListTile(
                            icon: IconlyBroken.infoSquare,
                            text: 'About the App',
                            action: () => openScreen(context, AboutPage()),
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            icon: IconlyBroken.call,
                            text: 'Contact us',
                            // TODO: For contact us page
                            action: () => openScreen(context, null),
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
                        openScreen(context, ProfileScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: tertiaryColor,
                              radius: 24,
                              backgroundImage: NetworkImage(
                                data['imageUrl'] ?? 'https://firebasestorage.googleapis.com/v0/b/wellfresh-f971a.appspot.com/o/userImages%2F1681064987.png?alt=media&token=45887028-8b4b-471f-b987-8454ab20d55c'
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
                                        color: secondaryTextColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        data['role'],
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(IconlyLight.arrowRight2)
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
                  child: CircularProgressIndicator()
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