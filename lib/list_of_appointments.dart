import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellfreshlogin/doctorSchedule.dart';
import 'package:wellfreshlogin/patient_details.dart';
import 'package:wellfreshlogin/widgets/navigation_drawer.dart';
import 'appointment_history_doctor.dart';
import 'get_image.dart';
import 'get_patient_details.dart';
import 'login.dart';

class list_of_patients extends StatefulWidget {
  const list_of_patients({Key? key}) : super(key: key);

  @override
  State<list_of_patients> createState() => _list_of_patientsState();
}

class _list_of_patientsState extends State<list_of_patients> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> patientID = [];
  List<String> day = [];
  List<String> month = [];
  List<String> time = [];
  List<String> patientRef = [];
  List<String> docRef = [];

  Future<void> getAppointment() async {
    if (patientID.isEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final finalQuerysnapshot = querySnapshot.collection('appointments');
      final querySnapshot2 = await finalQuerysnapshot.get();
      for (var patient in querySnapshot2.docs) {
        if (!patientID.contains(patient.id)) {
          if (patient['status'] == 'ongoing') {
            patientID.add(patient.id);
            patientRef.add(patient['patientReference']);
            docRef.add(patient['docReference']);
            month.add(patient['month']);
            time.add(patient['time']);
            day.add(patient['day'].toString());
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, // Add a Scaffold key
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white, // set the border color here
                  width: 2.0, // set the border width here
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.5), // set the shadow color here
                    spreadRadius: 1.0, // set the spread radius here
                    blurRadius: 5.0, // set the blur radius here
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          elevation: 0,
          title: const Text(
            "Appointments",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF8FAFF),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white, // set the border color here
                    width: 2.0, // set the border width here
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.5), // set the shadow color here
                      spreadRadius: 1.0, // set the spread radius here
                      blurRadius: 5.0, // set the blur radius here
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => appointment_history_doctor(),
                        ),
                      );
                    },
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
          // set app bar background color
        ),
        drawer: const NavigationDrawerWidget(),
        body: Container(
            color: Colors.white70,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Expanded(
                      child: FutureBuilder(
                        future: getAppointment(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: patientID.length,
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PatientDetails(
                                          appointmentId: patientID[index],
                                          docId: docRef[index],
                                          patientId: patientRef[index]),
                                    ));
                                  },
                                  child: SizedBox(
                                    height: 120.0,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: GetUserImage(
                                                documentId: patientRef[index])),
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: GetPatientDetails(
                                                    documentId:
                                                        patientRef[index]),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                child: Text(
                                                  '${month[index]} ${day[index]} 2023',
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 0, 0),
                                                    child: Text(
                                                      time[index],
                                                      style: const TextStyle(
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
                ),
              ],
            )));
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
