import 'package:flutter/material.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'About the App', backButton: false, color: surfaceColor, scaffoldKey: scaffoldKey),
      drawer: const NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 160,
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo/logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The Well Fresh Dental Clinic Application was made to cater the customer patients of The Well Fresh Dental Clinic that wants to book via their mobile devices.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The application features an appointment system for the patients visit to the clinic.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'It will also feature an e-commerce shop that sells over-the-counter dental products that Well Fresh Dental Clinic supports and uses.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'wellfresh_app, version 0.0.11',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: tertiaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
