import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/consts/consts.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = await firestore.collection('users').doc(user.uid).get();

      if (userData.exists) {
        setState(() {
          _nameController.text = userData['firstname'] + ' ' + userData['lastname'];
          _emailController.text =  userData['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Contact Us', backButton: false, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Submit',
        icon: IconlyBroken.send,
        action: () {
          if (_formKey.currentState!.validate()) {
            // Submit the form to the server
            firestore.collection('feedbacks')
            .add({
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'message': _messageController.text.trim(),
              'timestamp': FieldValue.serverTimestamp(),
            });
            Navigator.pop(context);
            FloatingSnackBar.show(context, 'Your feedback has been submitted!');
          }
        },
      ),
      drawer: const NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [containerShadow],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logo/logo.png',
                        width: 72,
                        height: 72,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WellFresh Dental Clinic Front Desk',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: primaryTextColor,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                            Text(
                              '9:00 AM - 6:00 PM',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: tertiaryTextColor,
                              )
                            ),
                            Text(
                              '09192122221',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: tertiaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Feel free to send us a message in the box below!',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  title: 'Name',
                  hintText: 'Name',
                  prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _emailController,
                  title: 'Email address',
                  hintText: 'Email address',
                  prefixIcon: const Icon(IconlyBroken.message, color: tertiaryTextColor),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _messageController,
                  title: 'Message',
                  hintText: 'Message',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: Icon(IconlyBroken.chat, color: tertiaryTextColor),
                  ),
                  lines: 8,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}