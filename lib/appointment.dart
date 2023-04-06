import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  String docId;
  AppointmentScreen({Key? key, required this.docId}) : super(key: key);
  @override
  State<AppointmentScreen> createState() => _AppointmentScreen();
}

class _AppointmentScreen extends State<AppointmentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int DateButtonIndex = 0;
  int TimeButtonIndex = 0;

  int _selectedMonth = DateTime.now().month - 1;

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<int> numbersInMonth = [];
  List<String> daysInMonths = [];

  List<int> getDayNumbersInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final List<int> days = [];
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
    numbersInMonth = days.cast<int>();
    return days;
  }

  List<String> getDayOfWeekInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final List<String> days = [];
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(year, month, i);
      final formatter = DateFormat('EEEE');
      final dayOfWeek = formatter.format(date);
      days.add(dayOfWeek);
    }
    daysInMonths = days;
    return days;
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _months.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                _months[index],
                style: TextStyle(
                  color: _selectedMonth == index
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedMonth = index;
                  getDayNumbersInMonth(2023, index + 1);
                  getDayOfWeekInMonth(2023, index + 1);
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    // Call your function here
    getDayNumbersInMonth(2023, currentMonth);
    getDayOfWeekInMonth(2023, currentMonth);
  }

  List<String> newTime = [];
  List<String> specialties = [];
  List<String> time = [];
  List<String> date = [];
  List<String> weekdays = [];
  List<String> months = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference listSpecialties = users.doc(widget.docId);
    DocumentReference listDate = users.doc(widget.docId);

    listSpecialties.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        specialties = List<String>.from(data['specialties']);
        print('List retrieved successfully!');
      } else {
        print('Document does not exist on the database');
        print(specialties);
      }
    }).catchError((error) => print('Failed to retrieve list: $error'));

    listDate.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        // Convert the Timestamp values to DateTime objects and format them as strings
        date = List<String>.from(data['date']
            .map((timestamp) => DateFormat('d').format(timestamp.toDate())));
        time = List<String>.from(data['date']
            .map((timestamp) => DateFormat('jm').format(timestamp.toDate())));
        weekdays = List<String>.from(data['date']
            .map((timestamp) => DateFormat('EEEE').format(timestamp.toDate())));
        months = List<String>.from(data['date']
            .map((timestamp) => DateFormat('MMMM').format(timestamp.toDate())));
        print('List retrieved successfully!');
        print(date);
        print(months);
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) => print('Failed to retrieve list: $error'));


    List<String> resetTime() {
      newTime = [];
      return newTime;
    }

    List<String> showTime(String month, int day) {
      String dayString = day.toString();
      newTime = [];
      for (int i = 0; i < time.length; i++) {
        if (months[i] == month && date[i] == dayString) {
          if (newTime.contains(time[i])) {
            continue;
          } else {
            newTime.add(time[i]);
          }
        } else {
          // newTime = [];
        }
      }
      return newTime;
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.docId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String firstname =
                data.containsKey('firstname') ? data['firstname'] : '';
            String lastname =
                data.containsKey('lastname') ? data['lastname'] : '';
            String biography =
                data.containsKey('biography') ? data['biography'] : '';
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 10),
                                      child: Text(
                                        specialties[0],
                                        style: const TextStyle(
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      '$firstname $lastname $biography',
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        height: 50.0,
                                        child: ListView.builder(
                                          itemCount: specialties.length,
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
                                                          BorderRadius.circular(
                                                              10.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 12, 0, 0),
                                                        child: Text(
                                                          specialties[index],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
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
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showMonthPicker(context);
                                              resetTime();
                                            },
                                            child: Text(
                                              _months[_selectedMonth],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  5), // Add some space between the icon and text
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        height: 75.0,
                                        child: ListView.builder(
                                          itemCount: numbersInMonth.length,
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
                                                      setState(() {
                                                        showTime(
                                                            _months[
                                                                _selectedMonth],
                                                            numbersInMonth[
                                                                index]);
                                                        DateButtonIndex =
                                                            index; // keep track of selected button index
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          DateButtonIndex ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black,
                                                      backgroundColor:
                                                          DateButtonIndex ==
                                                                  index
                                                              ? Colors.blue
                                                              : Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      elevation: 2.0,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 12, 0, 0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '${numbersInMonth[index]}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            daysInMonths[index],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                        ],
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
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        height: 50.0,
                                        child: ListView.builder(
                                          itemCount: newTime.length,
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
                                                      setState(() {
                                                        TimeButtonIndex =
                                                            index; // keep track of selected button index
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                      TimeButtonIndex ==
                                                          index
                                                          ? Colors.white
                                                          : Colors.black,
                                                      backgroundColor:
                                                      TimeButtonIndex ==
                                                          index
                                                          ? Colors.blue
                                                          : Colors.white,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(20.0),
                                                      ),
                                                      elevation: 2.0,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 2, 0, 0),
                                                      child: Text(
                                                        newTime[index],
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.w300,
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
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 19),
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
                              ),
                            ),
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
