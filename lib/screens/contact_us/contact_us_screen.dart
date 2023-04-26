import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Contact Us', backButton: false, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Submit',
        icon: IconlyBroken.send,
        action: () {
          FloatingSnackBar.show(context, 'Your feedback has been submitted!');
        },
      ),
      drawer: const NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
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
                controller: nameController,
                title: 'Name',
                hintText: 'Name',
                prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
              ),
              CustomTextField(
                controller: emailController,
                title: 'Email address',
                hintText: 'Email address',
                prefixIcon: const Icon(IconlyBroken.message, color: tertiaryTextColor),
              ),
              CustomTextField(
                controller: nameController,
                title: 'Message',
                hintText: 'Message',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 152),
                  child: Icon(IconlyBroken.chat, color: tertiaryTextColor),
                ),
                lines: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}