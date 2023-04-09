import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            String firstname = data.containsKey('firstname') ? data['firstname'] : '';
            String lastname = data.containsKey('lastname') ? data['lastname'] : '';
            String name = '$firstname $lastname';
            String email = FirebaseAuth.instance.currentUser!.email!;
            String phoneNumber = data.containsKey('phoneNumber') ? data['phoneNumber'] : '';
            String imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : ''; // changed key to 'imageUrl'

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: imageUrl != '' ? NetworkImage(imageUrl) : null,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 16),
                      SizedBox(width: 8),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, size: 16),
                      SizedBox(width: 8),
                      Text(
                        email,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '$phoneNumber',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Profile'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfile(),
                              ));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_month_outlined),
                            title: Text('View Appointments'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.shopping_cart),
                            title: Text('Purchase History'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Settings'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
