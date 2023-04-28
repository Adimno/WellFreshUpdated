import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfresh/consts/consts.dart';

class GetPatientImage extends StatelessWidget {
  final String documentId;

  const GetPatientImage({
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

          return data['imageUrl'] != null ? Image.network(data['imageUrl'], fit: BoxFit.cover)
          : Image.asset(defAvatar, fit: BoxFit.cover);
        }
        return Container();
      }),
    );
  }
}