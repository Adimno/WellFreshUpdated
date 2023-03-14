import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'get_user_name.dart';
import 'navigation_drawer_widget.dart';
import 'user_page.dart';

class Appointment extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String docId;

  Appointment({Key? key, required this.docId}) : super(key: key);



 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, // Add a Scaffold key
        backgroundColor: const Color(0xFFF8FAFF),
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white, // set the border color here
                  width: 2.0, // set the border width here
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.5), // set the shadow color here
                    spreadRadius: 1.0, // set the spread radius here
                    blurRadius: 5.0, // set the blur radius here
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          elevation: 0,
          title: Text(
            "Doctor's Detail",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFF8FAFF),
          // set app bar background color
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(35, 20, 0, 0),
          child: Column(
            children: [
              Container(
                height: 120.0,
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/photo.jpg'),
                    ),
                    Expanded(
                        child: SizedBox(
                      width: 150.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                            child: GetUserName(documentId: docId),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: Text(
                              'Dental Surgeon',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 18.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  '4.8',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
