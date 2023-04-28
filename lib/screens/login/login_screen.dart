import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePass = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: titleTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome to WellFresh!',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 50),
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
                      return 'Email cannot be empty';
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
                    icon: Icon(hidePass ? IconlyBroken.hide : IconlyBroken.show,
                      color: secondaryTextColor,
                    ),
                    onPressed: () {
                      setState(() { hidePass = !hidePass; });
                    },
                  ),
                  title: 'Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 140,
                    height: 55,
                    child: loading ? const Center(child: CircularProgressIndicator())
                    : ActionButton(
                      action: () {
                        setState(() { loading = true; });
                        signIn(emailController.text, passwordController.text);
                      },
                      backgroundColor: accentColor,
                      title: 'Sign in',
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Don\'t have an account?',
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
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      backgroundColor: tertiaryColor,
                      title: 'Sign up',
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

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        Get.offAll(() => const HomeScreen());
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          FloatingSnackBar.show(context, 'Invalid email format');
        } else if (e.code == 'user-not-found') {
          FloatingSnackBar.show(context, 'No user found for that email');
        } else if (e.code == 'wrong-password') {
          FloatingSnackBar.show(context, 'Invalid email or password');
        }
      }
    }
    setState(() { loading = false; });
  }
}