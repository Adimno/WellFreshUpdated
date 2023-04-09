import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserImage extends StatelessWidget {
  final String documentId;
  
  const GetUserImage({super.key, required this.documentId});
  @override
  Widget build(BuildContext context) {
    const String defaultImage = 'assets/photo.png';
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ((context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return data['imageUrl'];
          }
          return const Image(
            image: AssetImage('assets/photo.jpg'),
          );
        }));
  }
}
