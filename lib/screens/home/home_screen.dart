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
  
  Widget homeModule = const Center(child: CircularProgressIndicator());

  void displayUserScreen() async {
    try {
      DocumentSnapshot snapshot = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          if (data['role'].toLowerCase() == 'patient') {
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
    on FirebaseException catch (e) {
      if (e.code == 'resource-exhausted') {
        setState(() {
          homeModule = serverErrorScreen(context);
        });
      }
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
      body: homeModule,
    );
  }

  // If there's a problem with the server, display this
  Widget serverErrorScreen(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          const ItemIndicator(
            icon: Icons.sentiment_dissatisfied_outlined,
            text: 'Our servers are currently busy right now.',
          ),
          const SizedBox(height: 12),
          FittedBox(
            child: ActionButton(
              title: 'Reload app',
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize!,
              action: () {
                setState(() {
                  homeModule = const Center(child: CircularProgressIndicator());
                });
                displayUserScreen();
              }
            ),
          ),
          const Spacer(),
        ],
      ),
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