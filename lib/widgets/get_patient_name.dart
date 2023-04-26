import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/theme.dart';

class GetPatientName extends StatelessWidget {
  final String documentId;

  const GetPatientName({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(documentId).get(),
      builder: ((context, snapshot) {
        if(snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return Text(
            '${data['firstname']} ${data['lastname']}',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        return const Text('');
      }),
    );
  }
}