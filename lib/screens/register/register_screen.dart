import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/consts/consts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool hidePass = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: CustomAppBar(title: '', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height - 130,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: titleTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your WellFresh account.',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: firstnameController,
                  hintText: 'First name',
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(
                    IconlyBroken.paper,
                    color: secondaryTextColor,
                  ),
                  title: 'First name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: lastnameController,
                  hintText: 'Last name',
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(
                    IconlyBroken.paper,
                    color: secondaryTextColor,
                  ),
                  title: 'Last name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    IconlyBroken.message,
                    color: secondaryTextColor,
                  ),
                  title: 'Email',
                  validator: (value) {
                    RegExp regex = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: hidePass,
                  prefixIcon: const Icon(
                    IconlyBroken.password,
                    color: secondaryTextColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(hidePass ? IconlyBroken.hide: IconlyBroken.show,
                      color: secondaryTextColor,
                    ),
                    onPressed: () {
                      setState(() { hidePass = !hidePass; });
                    },
                  ),
                  title: 'Password',
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{6,}$');

                    if (value!.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid password with at least 6 characters';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: confirmpassController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  prefixIcon: const Icon(
                    IconlyBroken.password,
                    color: secondaryTextColor,
                  ),
                  title: 'Confirm Password',
                  validator: (value) {
                    if (confirmpassController.text != passwordController.text) {
                      return 'Password did not match';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: loading == false ? SizedBox(
                    width: 140,
                    height: 55,
                    child: ActionButton(
                      action: () async {
                        setState(() { loading = true; });
                        signUp(
                          email: emailController.text,
                          firstname: firstnameController.text,
                          lastname: lastnameController.text,
                          password: passwordController.text,
                        );
                      },
                      backgroundColor: accentColor,
                      title: 'Sign up',
                    ),
                  ) : const CircularProgressIndicator(),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 140,
                    height: 55,
                    child: ActionButton(
                      action: () {
                        const CircularProgressIndicator();
                        Navigator.pop(context);
                      },
                      backgroundColor: tertiaryColor,
                      title: 'Sign in',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp({
    email,
    firstname,
    lastname,
    password,
  }) async {
    if (_formkey.currentState!.validate()) {
      try {
        await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
          postDetailsToFirestore(
            email: email,
            firstname: firstname,
            lastname: lastname,
            password: password,
          )
        });
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          FloatingSnackBar.show(context, 'This email address already exists');
        }
      }
    }
    setState(() { loading = false; });
  }

  postDetailsToFirestore({
    email,
    firstname,
    lastname,
    password,
  }) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
      'role': 'Patient',
      'imageUrl': defAvatar,
      'created': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
    FloatingSnackBar.show(context, 'Congratulations! Your account is now registered!');
  }
}