import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorSchedule extends StatefulWidget {
  String docId;
  DoctorSchedule({Key? key, required this.docId}) : super(key: key);
  @override
  State<DoctorSchedule> createState() => _DoctorSchedule();
}

class _DoctorSchedule extends State<DoctorSchedule> {
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
    print(numbersInMonth);
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
    print(daysInMonths);
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
                  getDayNumbersInMonth(2023, index+1);
                  getDayOfWeekInMonth(2023, index+1);
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
    getDayNumbersInMonth(2023,currentMonth);
    getDayOfWeekInMonth(2023,currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference listSpecialties = users.doc(widget.docId);
    DocumentReference listDate = users.doc(widget.docId);

    List<String> specialties = [];
    List<String> time = [];
    List<String> amPmIndicators = [];
    List<String> date = [];
    List<String> weekdays = [];
    List<String> months = [];
    final List<String> weekdayNames = [
      'Mon',
      'Tues',
      'Wed',
      'Thurs',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<String> monthNames = [
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
      'December'
    ];

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
        time = List<String>.from(data['date'].map((timestamp) =>
            '${timestamp.toDate().hour}:${timestamp.toDate().minute}'));
        amPmIndicators = List<String>.from(data['date'].map((timestamp) {
          DateTime localDateTime = timestamp.toDate().toLocal();
          int hour = localDateTime.hour;
          return hour < 12
              ? 'AM'
              : 'PM'; // Extract the AM/PM indicator based on the hour value
        }));
        weekdays = List<String>.from(data['date']
            .map((timestamp) => weekdayNames[timestamp.toDate().weekday - 1]));
        months = List<String>.from(data['date']
            .map((timestamp) => monthNames[timestamp.toDate().month - 1]));
        print('List retrieved successfully!');
        print(date);
        print(time);
        print(amPmIndicators);
        print(weekdays);
        print(months);
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) => print('Failed to retrieve list: $error'));

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
                  "Schedule",
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
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          overlayColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  0),
                                          side: MaterialStateProperty.all<
                                              BorderSide>(BorderSide.none),
                                          shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                              const StadiumBorder()),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  _showMonthPicker(context),
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
                                          itemCount: time.length,
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
                                                        '${time[index]} ${amPmIndicators[index]}',
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
                                        )
                                    ),
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
                                  "Save",
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
