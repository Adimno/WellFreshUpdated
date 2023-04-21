import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNotes extends StatelessWidget {
  final String docID;
  final String appointmentId;
  const ViewNotes(
      {super.key, required this.docID, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference appointmentsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(docID)
        .collection('appointments');

    return FutureBuilder<DocumentSnapshot>(
      future: appointmentsRef.doc(appointmentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          List<String> notes = [];
          if (data != null && data['notes'] is Iterable?) {
            for (var note in data['notes'] ?? []) {
              notes.add(note);
            }
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                final doctorNotes = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(doctorNotes),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                );
              },
            );
        }
        return const Text('Loading...');
      }),
    );
  }
}