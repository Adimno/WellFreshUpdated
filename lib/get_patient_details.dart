import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPatientDetails extends StatelessWidget {
  final String documentId;
  const GetPatientDetails({super.key, required this.documentId});
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ((context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Text('${data['firstname']} ${data['lastname']}',
              style: const TextStyle(fontSize: 20.0,color: Colors.black,),);
          }
          return const Text('Loading...');
        }));
  }
}
