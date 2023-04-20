import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/custom_appbar.dart';

import 'appointment_history_patient.dart';
import 'trash/doctor.dart';

class PatientDetails extends StatefulWidget {
  String patientId;
  String docId;
  String appointmentId;
  PatientDetails(
      {Key? key,
      required this.appointmentId,
      required this.docId,
      required this.patientId})
      : super(key: key);
  @override
  State<PatientDetails> createState() => _AppointmentScreen();
}

class _AppointmentScreen extends State<PatientDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int day = 0;
  String month = '';
  String time = '';
  List notes = [];
  final _notesController = TextEditingController();
  String? _selectedNote;

  Future<void> getAppointmentDetails() async {
    final doctor =
        FirebaseFirestore.instance.collection('users').doc(widget.docId);
    final doctorQuerysnapshot =
        await doctor.collection('appointments').doc(widget.appointmentId).get();
    final appointmentData = doctorQuerysnapshot.data();
    if (appointmentData != null) {
      day = appointmentData['day'];
      month = appointmentData['month'];
      time = appointmentData['time'];
      notes.add(appointmentData['notes']);
      print(notes);
      print('${day} ${month} ${time}');
      // do something with patientName and appointmentTime
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    final doctorDocRef =
        FirebaseFirestore.instance.collection('users').doc(widget.docId);
    final appointmentQuerysnapshot =
        doctorDocRef.collection('appointments').doc(widget.appointmentId);

    appointmentQuerysnapshot.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        notes = List<String>.from(data['notes']);
        print('List retrieved successfully!');
      } else {
        print('Document does not exist on the database');
        print(notes);
      }
    }).catchError((error) => print('Failed to retrieve list: $error'));

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.patientId).get(),
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
                  title: 'Patient Details',
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PatientAppointmentHistory(
                                                          patientId: widget
                                                              .patientId)));
                                        },
                                        child: const Text(
                                          'View Appointment History',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          ),
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
                                children: [
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        '$month $day, 2023',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Time',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        time,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                    'Note',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Add a New Note'),
                                      content: TextFormField(
                                        controller: _notesController,
                                        decoration: InputDecoration(
                                          labelText: 'Note',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            String newNotes =
                                                _notesController.text.trim();
                                            if (newNotes.isNotEmpty) {
                                              // Save new specialty to Firestore
                                              appointmentQuerysnapshot.update({
                                                'notes': FieldValue.arrayUnion(
                                                    [newNotes])
                                              }).then((value) {
                                                setState(() {
                                                  notes.add(newNotes);
                                                  _selectedNote = newNotes;
                                                });
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Add a Note'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 0.0),
                          height: 350.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: notes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final doctorNotes = notes[index];
                              return Card(
                                child: ListTile(
                                  title: Text(doctorNotes),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Edit Note'),
                                                content: TextFormField(
                                                  controller: _notesController
                                                    ..text = doctorNotes,
                                                  decoration: InputDecoration(
                                                    labelText: 'Note',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      String updatedNote =
                                                          _notesController.text;
                                                      setState(() {
                                                        notes[index] =
                                                            updatedNote;
                                                        if (_selectedNote ==
                                                            doctorNotes) {
                                                          _selectedNote =
                                                              updatedNote;
                                                        }
                                                      });
                                                      // update specialties in Firestore
                                                      appointmentQuerysnapshot
                                                          .update({
                                                            'notes': FieldValue
                                                                .arrayUnion([
                                                              updatedNote
                                                            ]),
                                                          })
                                                          .then((value) => print(
                                                              'Note is added successfully'))
                                                          .catchError((error) =>
                                                              print(
                                                                  'Failed to add a note: $error'));
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          String specialty = notes[index];
                                          bool confirmed = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Delete a Note'),
                                              content: Text(
                                                  'Are you sure you want to delete this note?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: Text('Confirm'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirmed) {
                                            await FirebaseFirestore.instance
                                                .collection('specialties')
                                                .doc(specialty)
                                                .delete();
                                            setState(() {
                                              notes.removeAt(index);
                                              if (_selectedNote == specialty) {
                                                _selectedNote = notes.isEmpty
                                                    ? null
                                                    : notes[0];
                                              }
                                            });
                                            // delete specialty in Firestore
                                            appointmentQuerysnapshot.update({
                                              'notes': notes,
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedNote = doctorNotes;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text(
                                          "Are you sure you want to mark this appointment as done?"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the dialog
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() async {
                                              appointmentQuerysnapshot
                                                  .update({
                                                    'status': 'done',
                                                  })
                                                  .then((value) => {
                                                        print(
                                                            'status is changed to done'),
                                                        Navigator.pop(
                                                            context), // Close the dialog
                                                      })
                                                  .catchError((error) => {
                                                        print(
                                                            'Failed to change the status: $error'),

                                                        // Close the dialog
                                                      });
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Doctor(),
                                                ),
                                              );
                                            });
                                          },
                                          child: const Text(
                                            "Confirm",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 19),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Mark as Done",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
