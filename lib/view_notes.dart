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

    List<String> notes = [];
    String docReference = '';
    return FutureBuilder<DocumentSnapshot>(
        future: appointmentsRef.doc(appointmentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            docReference = data['docReference'];
            // notes.add(data['notes']);
            return AlertDialog(
              title: Text(docReference),
              content: const Text('Content'),
              actions: [
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    // do something
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
          return const Text('Loading...');
        }));
  }
}
