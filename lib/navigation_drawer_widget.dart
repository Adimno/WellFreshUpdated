import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/profile_screen.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'patient.dart';
import 'user_page.dart';
import 'about.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: FutureBuilder<DocumentSnapshot>(
          future: usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              String firstname = data.containsKey('firstname') ? data['firstname'] : '';
              String lastname = data.containsKey('lastname') ? data['lastname'] : '';
              String name = '$firstname $lastname';
              String email = FirebaseAuth.instance.currentUser!.email!; // get email from FirebaseAuth
              String imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : 'assets/images/defaultuser.png'; // get imageUrl from Firestore, default image used if imageUrl is null

              return ListView(
                children: <Widget>[
                  buildHeader(
                    urlImage: imageUrl,
                    name: name,
                    email: email,
                    onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserPage(
                        name: name,
                        urlImage: imageUrl,
                      ),
                    )),
                  ),
                  Container(
                    padding: padding,
                    child: Column(
                      children: [
                        Divider(color: Color.fromARGB(179, 0, 0, 0)),
                        const SizedBox(height: 12),
                        const SizedBox(height: 24),
                        buildMenuItem(
                          text: 'Profile',
                          icon: Icons.person,
                          onClicked: () => selectedItem(context, 0),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'Home',
                          icon: Icons.home_filled,
                          onClicked: () => selectedItem(context, 1),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'Appointment',
                          icon: Icons.calendar_month,
                          onClicked: () => selectedItem(context, 2),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'Dental Store',
                          icon: Icons.shopping_bag,
                          onClicked: () => selectedItem(context, 3),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'About App',
                          icon: Icons.question_mark,
                          onClicked: () => selectedItem(context, 4),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'Contact Us',
                          icon: Icons.dialer_sip_outlined,
                          onClicked: () => selectedItem(context, 5),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.grey.shade700;
    final hoverColor = Colors.grey.shade800;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    VoidCallback? onClicked,
  }) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(urlImage),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Patient(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const StoreScreen(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AboutPage(),
        ));
        break;

    }
  }
}

