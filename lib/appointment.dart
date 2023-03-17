import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String docId;

  Appointment({Key? key, required this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(docId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String firstname =
                data.containsKey('firstname') ? data['firstname'] : '';
            String lastname =
                data.containsKey('lastname') ? data['lastname'] : '';
            return Scaffold(
              key: _scaffoldKey, // Add a Scaffold key
              backgroundColor: const Color(0xFFF8FAFF),
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                elevation: 0,
                title: const Text(
                  "Doctor's Detail",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFFF8FAFF),
                // set app bar background color
              ),
              body: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        child: SizedBox(
                          height: 120.0,
                          child: Row(
                            children: [
                                ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: const Image(
                                  image: AssetImage('assets/photo.png'),
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                width: 150.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 5),
                                      child: Text(
                                        '$firstname $lastname',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 10),
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
                                          padding:
                                              EdgeInsets.fromLTRB(8, 0, 0, 0),
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 18.0,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Biography',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      '$firstname $lastname is a medical professional who specializes in the diagnosis, prevention, and treatment of diseases and conditions of the teeth and oral cavity.',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Specialties',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        height: 50.0,
                                        child: ListView.builder(
                                          itemCount: 10,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 5, 0, 5),
                                                  child: Container(
                                                    width: 160.0,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 1,
                                                          offset:
                                                              const Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Padding(
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                                0, 12, 0, 0),
                                                        child: Text(
                                                          'Dental Surgeon',
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width:
                                                        20.0), // Add space between containers
                                              ],
                                            );
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Your button action here
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                          elevation: MaterialStateProperty.all<double>(0),
                                          side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
                                          shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
                                        ),
                                        child: Row(
                                          children: const [
                                            Text(
                                              'January',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: 5), // Add some space between the icon and text
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.black,
                                              size: 15,
                                            ),
                                          ],
                                        ),

                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        height: 75.0,
                                        child: ListView.builder(
                                          itemCount: 10,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 0, 0, 5),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Add your button press logic here
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      elevation: 2.0,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                                      child: Column(
                                                        children: const [
                                                          Text(
                                                            '1',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Mon',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ),
                                                const SizedBox(
                                                    width:
                                                        20.0), // Add space between containers
                                              ],
                                            );
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        height: 50.0,
                                        child: ListView.builder(
                                          itemCount: 10,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 5, 0, 5),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      elevation: 2.0,
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                                      child: Text(
                                                        '01:00 AM',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 15.0,

                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width:
                                                    20.0), // Add space between containers
                                              ],
                                            );
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child:
                            ElevatedButton(
                              onPressed: () {

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 19),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Book Appointment",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }
}
