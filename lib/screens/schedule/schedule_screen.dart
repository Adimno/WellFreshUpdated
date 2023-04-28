import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';

class ScheduleScreen extends StatefulWidget {
  final String docId;

  const ScheduleScreen({
    super.key,
    required this.docId,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedMonthIndex = DateTime.now().month - 1;
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;

  List<String> newTime = [];
  List<String> time = [];
  List<String> date = [];
  List<String> weekdays = [];
  List<String> months = [];

  List<int> numbersInMonth = [];
  List<String> daysInMonths = [];

  TimeOfDay timeOfDay = const TimeOfDay(hour: 12, minute: 00);

  static const List<String> allMonths = [
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

  List<int> getDaysInMonth(int year, int month) {
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
      final formatter = DateFormat('EEE');
      final dayOfWeek = formatter.format(date);

      days.add(dayOfWeek);
    }
    daysInMonths = days;
    return days;
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
      }
    }
    return newTime;
  }

  List<String> showAvailDots(String month, int day) {
    String dayString = day.toString();
    List<String> availSlots = [];

    for (int i = 0; i < time.length; i++) {
      if (months[i] == month && date[i] == dayString) {
        if (availSlots.contains(time[i])) {
          continue;
        } else {
          availSlots.add(time[i]);
        }
      }
    }
    return availSlots;
  }

  @override
  void initState() {
    super.initState();
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    getDaysInMonth(currentYear, currentMonth);
    getDayOfWeekInMonth(currentYear, currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Schedules', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirestoreServices.getTargetUser(widget.docId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: RefreshProgressIndicator()
            );
          }
          else {
            var data = snapshot.data!.data();

            if (data!['date'] != null) {
              date = List<String>.from(data['date'].map((timestamp) => DateFormat('d').format(timestamp.toDate())));
              time = List<String>.from(data['date'].map((timestamp) => DateFormat('jm').format(timestamp.toDate())));
              weekdays = List<String>.from(data['date'].map((timestamp) => DateFormat('EEEE').format(timestamp.toDate())));
              months = List<String>.from(data['date'].map((timestamp) => DateFormat('MMMM').format(timestamp.toDate())));
            }

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Date',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: primaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(28),
                                ),
                              ),
                              backgroundColor: surfaceColor,
                              builder: (context) => DraggableScrollableSheet(
                                expand: false,
                                builder: (context, scrollController) => SingleChildScrollView(
                                  controller: scrollController,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 5,
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: allMonths.length,
                                          itemBuilder: (context, index) {
                                            return CustomListTile(
                                              icon: IconlyBroken.calendar,
                                              text: allMonths[index],
                                              selected: selectedMonthIndex == index ? true : false,
                                              action: () {
                                                setState(() {
                                                  selectedMonthIndex = index;
                                                  selectedDayIndex = -1;
                                                  newTime = [];
              
                                                  getDaysInMonth(DateTime.now().year, index + 1);
                                                  getDayOfWeekInMonth(DateTime.now().year, index + 1);
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                allMonths[selectedMonthIndex],
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: tertiaryTextColor,
                                ),
                              ),
                              const Icon(
                                IconlyLight.arrowRight2,
                                color: tertiaryTextColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        itemCount: numbersInMonth.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                showTime(allMonths[selectedMonthIndex], numbersInMonth[index]);
                                selectedDayIndex = numbersInMonth[index];
              
                                selectedTimeIndex = -1;
                              });
                            },
                            child: AnimatedContainer(
                              width: 60,
                              height: 64,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: selectedDayIndex == numbersInMonth[index] ? accentColor : cardColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [containerShadow],
                              ),
                              duration: const Duration(milliseconds: 150),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    numbersInMonth[index].toString(),
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: selectedDayIndex == numbersInMonth[index] ? invertTextColor : primaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    daysInMonths[index],
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: selectedDayIndex == numbersInMonth[index] ? fadeTextColor : tertiaryTextColor,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: showAvailDots(allMonths[selectedMonthIndex], index + 1).isNotEmpty ?
                                    selectedDayIndex == index + 1 ? cardColor
                                    : accentColor
                                    : Colors.transparent,
                                    radius: 3,
                                  )
                                ],
                              )
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: primaryTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        selectedDayIndex != -1 ? ActionButton(
                          title: 'Add a schedule',
                          fontSize: 14,
                          action: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: timeOfDay,
                            );
                            if (pickedTime != null) {
                              setState(() {
                                timeOfDay = pickedTime;

                                final String userId = FirebaseAuth.instance.currentUser!.uid;
                                final doctorDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

                                final DateTime date = DateTime(2023, selectedMonthIndex + 1, selectedDayIndex);
                                final TimeOfDay time = timeOfDay; // use your own time here
                                final Timestamp timestamp = Timestamp.fromDate(DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                ));

                                doctorDocRef.update({
                                  'date': FieldValue.arrayUnion([timestamp]),
                                }).then((value) {
                                  FloatingSnackBar.show(context, 'Schedule added successfully!');
                                }).catchError((error) {
                                  FloatingSnackBar.show(context, 'Failed to add schedule');
                                });
                                newTime.add(timeOfDay.format(context));
                                selectedTimeIndex = newTime.length - 1;
                              });
                            }
                          }
                        ) : Container(),
                      ],
                    ),
                    newTime.isNotEmpty ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [containerShadow],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: newTime.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.only(left: 24, right: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  IconlyBroken.timeCircle,
                                  color: tertiaryTextColor,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    newTime[index],
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(color: borderColor);
                        },
                      ),
                    ) : Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: const ItemIndicator(
                        icon: IconlyBroken.calendar,
                        text: 'No available schedules for this day',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}