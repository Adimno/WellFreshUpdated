import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetDoctorName extends StatelessWidget {
  final String documentId;
  const GetDoctorName({super.key, required this.documentId});
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Text(
              'Dr. ${data['firstname']} ${data['lastname']}',
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.black54,
              ),
            );
          }
          return const Text('Loading...');
        }));
  }
}
