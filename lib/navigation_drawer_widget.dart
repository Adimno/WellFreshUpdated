import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/profile_screen.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'patient.dart';
import 'user_page.dart';
import 'about.dart';
import 'doctor.dart';




class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  late String userRole;

  Future<bool> isAuthenticatedAsPatient() async {
    // Check if the user is authenticated and has a "patient" role
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot snapshot =
      await usersCollection.doc(currentUser.uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data.containsKey('role') && data['role'] == 'patient';
    }
    return false;
  }


  Future<void> _checkUserRole() async {
    if (await isAuthenticatedAsPatient()) {
      userRole = 'Patient';
    } else {
      userRole = 'Doctor';
    }
  }

  @override
  Widget build(BuildContext context) {

    _checkUserRole();

    return Drawer(
      child: Material(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: FutureBuilder<DocumentSnapshot>(
          future:
              usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              String firstname =
                  data.containsKey('firstname') ? data['firstname'] : '';
              String lastname =
                  data.containsKey('lastname') ? data['lastname'] : '';
              String name = '$firstname $lastname';
              String email = FirebaseAuth
                  .instance.currentUser!.email!; // get email from FirebaseAuth

              return ListView(
                children: <Widget>[
                  buildHeader(
                    urlImage:
                        'https://www.seekpng.com/png/full/356-3562377_personal-user.png',
                    name: name,
                    email: email,
                    onClicked: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserPage(
                        name: name,
                        urlImage:
                            'https://www.seekpng.com/png/full/356-3562377_personal-user.png',
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
                        if (userRole == 'Patient') ...[
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
                        ],
                        if (userRole == 'Doctor') ...[
                          buildMenuItem(
                            text: 'Profile',
                            icon: Icons.person,
                            onClicked: () => selectedItem(context, 00),
                          ),
                          const SizedBox(height: 16),
                          buildMenuItem(
                            text: 'Home',
                            icon: Icons.home_filled,
                            onClicked: () => selectedItem(context, 11),
                          ),
                          const SizedBox(height: 16),
                          buildMenuItem(
                            text: 'Appointments',
                            icon: Icons.calendar_month,
                            onClicked: () => selectedItem(context, 22),
                          ),
                          const SizedBox(height: 16),
                          buildMenuItem(
                            text: 'Patients',
                            icon: Icons.people,
                            onClicked: () => selectedItem(context, 33),
                          ),
                        ],
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

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Color.fromARGB(255, 0, 0, 0);
    final hoverColor = Color.fromARGB(179, 193, 188, 188);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    bool isPatient = await isAuthenticatedAsPatient();

    if (isPatient) {
      switch (index) {
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ));
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
    } else {
      // not patient
      switch (index) {
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ));
          break;
        case 1:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Doctor(),
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
}
