import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wellfreshlogin/appointment.dart';
import 'package:wellfreshlogin/get_user_name.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'get_image.dart';
import 'login.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> docIDs = [];
  Future<void> getDocId() async {
    if (docIDs.isEmpty) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (int i = 0; i < querySnapshot.size; i++) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[i];
        String docId = documentSnapshot.reference.id;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (data['role'] == 'Doctor' && !docIDs.contains(docId)) {
          docIDs.add(docId);
          if (kDebugMode) {
            print('${documentSnapshot.reference} count:$i');
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDocId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, // Add a Scaffold key
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!
                  .openDrawer(); // Use Scaffold key to open drawer
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Add functionality to show notifications
              },
              icon: const Icon(
                Icons.notifications,
              ),
            ),
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(
                Icons.logout,
              ),
            )
          ],
        ),
        drawer: const NavigationDrawerWidget(),
        body: Container(
          color: Colors.white70,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: FutureBuilder(
                  future: usersCollection
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      String firstname = data.containsKey('firstname')
                          ? data['firstname']
                          : '';
                      String lastname =
                          data.containsKey('lastname') ? data['lastname'] : '';

                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(25.0, 30.0, 12.0, 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Hi, $firstname $lastname',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(25.0, 0, 12.0, 20.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Let's find your top doctor!",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(360, 70),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search here...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                fillColor: Colors.white,
                              ),
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
              const Padding(
                padding: EdgeInsets.fromLTRB(25.0, 30.0, 12.0,
                    20.0), // add padding to top, left, and right
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Doctors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Expanded(
                  child: FutureBuilder(
                    future: getDocId(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AppointmentScreen(docId: docIDs[index]),
                                ));
                              },
                              child: SizedBox(
                                height: 120.0,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: GetUserImage(
                                            documentId: docIDs[index])),
                                    Expanded(
                                        child: SizedBox(
                                      width: 150.0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: GetUserName(
                                                documentId: docIDs[index]),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                              'Dental Surgeon',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 18.0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                child: Text(
                                                  '4.8',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
