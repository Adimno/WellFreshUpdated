import 'package:flutter/material.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';

class AboutPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add a Scaffold key
      backgroundColor: Colors.white, // set background color
      appBar: AppBar(
        title: Text('About the Application'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer(); // Use Scaffold key to open drawer
          },
        ),
        // set app bar background color
      ),
      drawer: NavigationDrawerWidget(),
      body: Container(
        margin: EdgeInsets.fromLTRB(16, 32, 16, 0), // set margin for container
        child: Column(
          children: [
            Container(
              height: 300, // set height of the image container
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/dentallogo.png'), // add image path
                  // set image fit
                ),
              ),
            ),
            SizedBox(height: 16), // add spacing
            Card(
              margin: EdgeInsets.all(16), // set margin for the card
              child: Padding(
                padding: EdgeInsets.all(16), // set padding for the card content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome to our App!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16), // add spacing
                    Text(
                      'The Well Fresh Dental Clinic Application was made to cater the customer patients of The Well Fresh Dental Clinic that wants to book via their mobile devices.'
                          'The application features an appointment system for the patients visit to the clinic.'
                          'It will also feature an e-commerce shop that sells over-the-counter dental products that Well Fresh Dental Clinic supports and uses.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
