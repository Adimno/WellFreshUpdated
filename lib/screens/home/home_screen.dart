import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/consts/consts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = FirebaseFirestore.instance.collection(usersCollection);
  
  Widget homeModule = Container();

  void displayUserScreen() async {
    DocumentSnapshot snapshot = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        if (data['role'] == 'Patient') {
          homeModule = PatientModule(firstname: data['firstname']);
        }
        else {
          homeModule = DoctorModule(firstname: data['firstname']);
        }
      });
    }
    else {
      invalidSession();
    }
  }

  @override
  void initState() {
    super.initState();
    displayUserScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeModule == Container() ? const Center(child: CircularProgressIndicator()) : homeModule,
    );
  }

  // If session is invalid, force log out the user
  invalidSession() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginScreen());
    Future.delayed(Duration.zero).then((value) =>
      FloatingSnackBar.show(context, 'Invalid user session. Logging out...')
    );
  }
}