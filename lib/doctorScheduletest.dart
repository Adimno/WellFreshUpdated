import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';


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


  List<String> newTime = [];
  List<String> specialties = [];
  List<String> time = [];
  List<String> date = [];
  List<String> weekdays = [];
  List<String> months = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference listDate = users.doc(widget.docId);


    void showEditDialog(BuildContext context, int index) {
      String editedTime = newTime[index];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Time'),
            content: TextField(
              autofocus: true,
              controller: TextEditingController(text: editedTime),
              onChanged: (value) {
                editedTime = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('SAVE'),
                onPressed: () async {
                  String updatedTime = editedTime;

                  // Update time in Firestore

                  final FirebaseFirestore firestore = FirebaseFirestore.instance;
                  final CollectionReference appointmentCollection =
                  firestore.collection('users').doc(widget.docId).collection('appointments');
                  final DocumentReference appointmentDoc = appointmentCollection.doc(date[DateButtonIndex]);

                  await appointmentDoc.update({
                    'time': FieldValue.arrayRemove([time[TimeButtonIndex]]),
                    'time': FieldValue.arrayUnion([updatedTime]),
                  });

                  // Update time in appointment object
                  setState(() {
                    newTime[index] = updatedTime;
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }




    void showDeleteDialog(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Time'),
            content: const Text('Are you sure you want to delete this time?'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('DELETE'),
                onPressed: () {
                  setState(() {
                    newTime.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    listDate.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        // Convert the Timestamp values to DateTime objects and format them as strings
        date = List<String>.from(data['date']
            .map((timestamp) => DateFormat('d').format(timestamp.toDate())));
        time = List<String>.from(data['date'].map((timestamp) => DateFormat('jm').format(timestamp.toDate())));
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

    TimeOfDay timeOfDay = const TimeOfDay(hour: 12, minute: 00);


    List<String> resetTime(){
      newTime = [];
      return newTime;
    }



    List<String> showTime(String month, int day){
      String dayString = day.toString();
      newTime = [];
      for(int i=0; i <time.length; i++){
        if(months[i] == month && date[i] == dayString){
          if(newTime.contains(time[i])){
            continue;
          } else {
            newTime.add(time[i]);
          }
        } else{
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
                                        height: 80.0,
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
                                                        showTime(_months[_selectedMonth], numbersInMonth[index]);
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
                                  Row(children: [
                                    const Text(
                                      'Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: timeOfDay,
                                          );
                                          if (pickedTime != null) {
                                            setState(() {
                                              timeOfDay = pickedTime;

                                              // Get the current user ID from Firebase Auth
                                              final String userId = FirebaseAuth.instance.currentUser!.uid;

                                              // Create a reference to the doctor's user document
                                              final doctorDocRef = FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(userId);

                                              final DateTime date = DateTime(2023, _selectedMonth+1, numbersInMonth[DateButtonIndex]); // use your own date here
                                              final TimeOfDay time = timeOfDay; // use your own time here
                                              print(timeOfDay);
                                              final Timestamp timestamp = Timestamp.fromDate(DateTime(
                                                date.year, // year
                                                date.month, // month
                                                date.day, // day
                                                time.hour, // hour
                                                time.minute, // minute
                                              ));



                                              doctorDocRef.update({
                                                'date': FieldValue.arrayUnion([timestamp]),
                                              }).then((value) => print('Schedule added successfully'))
                                                  .catchError((error) => print('Failed to add schedule: $error'));

                                              newTime.add(timeOfDay.format(context));
                                              TimeButtonIndex = newTime.length - 1;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text(
                                          "Add a time",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 0.0),
                                      height: 50.0,
                                      child: ListView.builder(
                                        itemCount: newTime.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      TimeButtonIndex = index; // keep track of selected button index
                                                    });

                                                    // Handle edit and delete operations
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text('Edit or Delete Time'),
                                                          content: SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                    showEditDialog(context, index);
                                                                  },
                                                                  child: const Text('Edit Time'),
                                                                ),
                                                                const SizedBox(height: 10),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                    showDeleteDialog(context, index);
                                                                  },
                                                                  child: const Text('Delete Time'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: TimeButtonIndex == index ? Colors.white : Colors.black,
                                                    backgroundColor: TimeButtonIndex == index ? Colors.blue : Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    elevation: 2.0,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                                    child: Text(
                                                      newTime[index],
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20.0), // Add space between containers
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
