import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/consts/consts.dart';
import 'package:wellfresh/services/firebase_services.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';

class AppointmentScreen extends StatefulWidget {
  final String docId;

  const AppointmentScreen({
    super.key,
    required this.docId,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedMonthIndex = DateTime.now().month - 1;
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;
  int currentYear = 1900;

  List<String> newTime = [];
  List<String> time = [];
  List<String> date = [];
  List<String> weekdays = [];
  List<String> months = [];

  List<int> numbersInMonth = [];
  List<String> daysInMonths = [];

  bool toggleView = true;

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

  static const List<String> daysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
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
    currentYear = DateTime.now().year;

    getDaysInMonth(currentYear, currentMonth);
    getDayOfWeekInMonth(currentYear, currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Doctor\'s Detail', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: selectedTimeIndex != -1 ? CustomNavBar(
        title: 'Book Appointment',
        action: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: surfaceColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                title: Text(
                  'Important Reminder',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failure to go to your appointment will incur a charge of 500 pesos. This is due to the high volume of patients who want to settle an appointment. This fee shall be collected on your next visit in our clinic.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ActionButton(
                          title: 'Cancel',
                          backgroundColor: cardColor,
                          foregroundColor: accentTextColor,
                          fontSize: 14,
                          action: () => Navigator.pop(context),
                        ),
                        ActionButton(
                          title: 'Confirm',
                          backgroundColor: accentColor,
                          foregroundColor: invertTextColor,
                          fontSize: 14,
                          action: () {
                            setState(() {
                              // Add appointment info to appointments
                              firestore.collection(appointmentsCollection)
                              .add({
                                'docId': widget.docId,
                                'patientId': FirebaseAuth.instance.currentUser!.uid,
                                'time': newTime[selectedTimeIndex],
                                'day': selectedDayIndex,
                                'month': allMonths[selectedMonthIndex],
                                'year': DateTime.now().year,
                                'status': 'ongoing',
                                'notes': [],
                              }).then((value) {
                                // Add appointment notification to doctor
                                firestore.collection(usersCollection)
                                .doc(widget.docId)
                                .collection('notifications')
                                .doc()
                                .set({
                                  'type': 'appointment',
                                  'role': 'doctor',
                                  'message': 'You have a new appointment: #${value.id.substring(0, 7)}',
                                  'reference': value.id,
                                  'read': false,
                                  'date': FieldValue.serverTimestamp(),
                                });
                              }).catchError((error) {
                                FloatingSnackBar.show(context, 'Error: Failed to add appointment');
                                return error;
                              });
                            });
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: surfaceColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(24))
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  title: Text(
                                    'Appointment booked',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: secondaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Your scheduled date is on ${allMonths[selectedMonthIndex]} $selectedDayIndex at ${newTime[selectedTimeIndex]}',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ActionButton(
                                            title: 'OK',
                                            backgroundColor: accentColor,
                                            foregroundColor: invertTextColor,
                                            fontSize: 14,
                                            action: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ) : null,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 94,
                          height: 94,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: data.containsKey('imageUrl') ? Image.network(
                            data['imageUrl'],
                            fit: BoxFit.cover,
                          ) : Image.asset(
                            defAvatar,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${data['firstname']} ${data['lastname']}',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (data.containsKey('verified') && data['verified']) ...[
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.verified,
                                    color: accentColor,
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              data.containsKey('specialties') ? data['specialties'][0] : 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: tertiaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  IconlyBold.star,
                                  color: warningTextColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '4.8',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: tertiaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: data['date'] != null ? accentColor : errorColor,
                                  size: 8,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  data['date'] != null ? '${data['date'].length} slots available' : 'Unavailable',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: data['date'] != null ? accentColor : errorColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Biography',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: tertiaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['biography'] ?? 'No description available',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Specialties',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: tertiaryTextColor,
                      ),
                    ),
                    data.containsKey('specialties') ? PillCarousel(data: data['specialties'])
                    : Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No specialties available',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
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
                                                  selectedTimeIndex = -1;
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
                                '${allMonths[selectedMonthIndex]} $currentYear',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                IconlyLight.arrowDown2,
                                color: tertiaryTextColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              toggleView = !toggleView;
                            });
                          },
                           child: Text(
                            toggleView ? 'Calendar View' : 'Scroll View',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: accentTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    toggleView == false ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: const [containerShadow],
                      ),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: daysOfWeek.length,
                            itemBuilder:(context, index) {
                              return Center(
                                child: Text(
                                  daysOfWeek[index],
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: tertiaryTextColor,
                                  ),
                                ),
                              );
                            },
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.1,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: numbersInMonth.length + daysOfWeek.indexOf(daysInMonths[0]),
                            itemBuilder:(context, index) {
                              if (index < daysOfWeek.indexOf(daysInMonths[0])) {
                                return const Text('');
                              }
                              int totalDays = index - daysOfWeek.indexOf(daysInMonths[0]);
                    
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showTime(allMonths[selectedMonthIndex], numbersInMonth[totalDays]);
                                    selectedDayIndex = numbersInMonth[totalDays];
                                    
                                    selectedTimeIndex = -1;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedDayIndex == numbersInMonth[totalDays] ? accentColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(99),
                                        boxShadow: const [containerShadow],
                                      ),
                                      duration: const Duration(milliseconds: 150),
                                      child: Text(
                                        numbersInMonth[totalDays].toString(),
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: selectedDayIndex == numbersInMonth[totalDays] ? invertTextColor : primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: showAvailDots(allMonths[selectedMonthIndex], totalDays + 1).isNotEmpty ?
                                      accentColor
                                      : Colors.transparent,
                                      radius: 3,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ) : Container(
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
                    Text(
                      'Time',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    newTime.isNotEmpty ? Container(
                      height: 36,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        itemCount: newTime.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTimeIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              width: 90,
                              height: 36, 
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: selectedTimeIndex == index ? accentColor : cardColor,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: const [containerShadow],
                              ),
                              duration: const Duration(milliseconds: 150),
                              child: Center(
                                child: Text(
                                  newTime[index],
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: selectedTimeIndex == index ? invertTextColor : primaryTextColor,
                                  ),
                                ),
                              )
                            ),
                          );
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