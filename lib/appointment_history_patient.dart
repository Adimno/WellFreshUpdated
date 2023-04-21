import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellfreshlogin/get_doctor_name.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/view_notes.dart';
import 'package:wellfreshlogin/widgets/custom_appbar.dart';

import 'get_user_name.dart';

class PatientAppointmentHistory extends StatefulWidget {
  String patientId;
  PatientAppointmentHistory({Key? key, required this.patientId})
      : super(key: key);
  @override
  State<PatientAppointmentHistory> createState() => _AppointmentScreen();
}

class _AppointmentScreen extends State<PatientAppointmentHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> appointments = [];
  List<String> day = [];
  List<String> month = [];
  List<String> time = [];
  List<String> appointmentReference = [];
  List<String> docReference = [];

  Future<void> getAppointmentDetails() async {
    if (appointments.isEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.patientId);
      final finalQuerysnapshot = querySnapshot.collection('appointments');
      final querySnapshot2 = await finalQuerysnapshot.get();
      for (var patient in querySnapshot2.docs) {
        if (!appointments.contains(patient.id)) {
          appointments.add(patient.id);
          month.add(patient['month']);
          day.add(patient['day'].toString());
          time.add(patient['time']);
          appointmentReference.add(patient['appointmentReference']);
          docReference.add(patient['docReference']);
        }
      }
    }
    print(appointments);
    print(month);
    print(day);
    print(time);
    print(appointmentReference);
    print(docReference);
  }

  @override
  void initState() {
    super.initState();
    getAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseFirestore.instance.collection('users').doc(widget.patientId);

    return FutureBuilder<DocumentSnapshot>(
        future: user.get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String firstname =
                data.containsKey('firstname') ? data['firstname'] : '';
            String lastname =
                data.containsKey('lastname') ? data['lastname'] : '';
            String phoneNumber =
                data.containsKey('phoneNumber') ? data['phoneNumber'] : '';
            String imageUrl =
                data.containsKey('imageUrl') ? data['imageUrl'] : '';
            String email = data.containsKey('email') ? data['email'] : '';
            return Scaffold(
              key: _scaffoldKey, // Add a Scaffold key
              backgroundColor: const Color(0xFFF8FAFF),
              appBar: CustomAppBar(
                  title: "Patient's History",
                  backButton: true,
                  color: surfaceColor,
                  scaffoldKey: _scaffoldKey),
              body: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        child: SizedBox(
                          height: 120.0,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  imageUrl,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    // If the URL is null or returns an error, return a default image.
                                    return Image.asset('assets/photo.jpg');
                                  },
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                width: 150.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Text(
                                        '$firstname $lastname',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 5),
                                      child: Text(
                                        phoneNumber,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 10),
                                      child: Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'History',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: getAppointmentDetails(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: SizedBox(
                                      height: 120.0,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: SizedBox(
                                                  width: 150.0,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 0, 5),
                                                        child: Text(
                                                          '${month[index]} ${day[index]}, 2023',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 0, 0),
                                                        child: Text(
                                                          time[index],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  20, 0, 0, 0),
                                                          child: GetDoctorName(
                                                            documentId:
                                                                docReference[
                                                                    index],
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 20, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // showDialog(
                                                      //   context: context,
                                                      //   builder: (BuildContext context) {
                                                      //     return ViewNotes(docID: docReference[
                                                      //     index], appointmentId: appointmentReference[index],);
                                                      //   },
                                                      // );
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Row(
                                                              children: [
                                                                GetDoctorName(
                                                                  documentId:
                                                                      docReference[
                                                                          index],
                                                                ),
                                                                Text("'s note", style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Colors.black54,
                                                                ),)
                                                              ],
                                                            ),
                                                            content: SizedBox(
                                                              height: 300,
                                                              width: 800,
                                                              child: ViewNotes(
                                                                docID:
                                                                    docReference[
                                                                        index],
                                                                appointmentId:
                                                                    appointmentReference[
                                                                        index],
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text('OK'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 30,
                                                          vertical: 16),
                                                      elevation: 5,
                                                    ),
                                                    child: const Text(
                                                        'View Notes'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            },
                            padding: EdgeInsets.only(bottom: 16.0),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }
}
