import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/consts/consts.dart';
import 'package:wellfresh/services/firebase_services.dart';

class AppointmentDetailsPatientScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailsPatientScreen({
    required this.appointmentId,
    super.key,
  });

  @override
  State<AppointmentDetailsPatientScreen> createState() => _AppointmentDetailsPatientScreenState();
}

class _AppointmentDetailsPatientScreenState extends State<AppointmentDetailsPatientScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var userId = FirebaseFirestore.instance.collection(usersCollection);

  List<String> notes = [];
  String status = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment Details', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: status != '' ? Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(
              IconlyBroken.infoCircle,
              color: tertiaryTextColor,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                status == 'ongoing' ? 'This appointment cannot be cancelled.'
                : 'This appointment has been closed.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: tertiaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ) : null,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirestoreServices.getAppointment(widget.appointmentId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            var data = snapshot.data!.data();

            notes = [];
            List<dynamic> notesTmp = data!['notes'] ?? [];
            notes.addAll(notesTmp.cast<String>());

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                status = data['status'];
              });
            });

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Assigned Doctor',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirestoreServices.getTargetUser(data['docId']),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        else {
                          var userData = snapshot.data!.data();
          
                          return Container(
                            clipBehavior: Clip.hardEdge,
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: const [containerShadow],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: 72,
                                  height: 72,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: userData!.containsKey('imageUrl') ? Image.network(userData['imageUrl'], fit: BoxFit.cover)
                                  : Image.asset(defAvatar, fit: BoxFit.cover),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${userData['firstname']} ${userData['lastname']}',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (userData.containsKey('verified') && userData['verified']) ...[
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
                                      userData.containsKey('specialties') ? userData['specialties'][0] : 'N/A',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: tertiaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      userData['email'],
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: tertiaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Schedule',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: double.infinity,
                      height: 70,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [containerShadow],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  IconlyBroken.calendar,
                                  color: tertiaryTextColor,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: tertiaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      '${data['month']} ${data['day']}, ${data['year']}',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  IconlyBroken.timeCircle,
                                  color: tertiaryTextColor,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: tertiaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      data['time'],
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Notes',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [containerShadow],
                      ),
                      child: notes.isNotEmpty ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: notes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.only(left: 24, right: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  IconlyBroken.paper,
                                  color: tertiaryTextColor,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    notes[index],
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
                      ) : const Padding(
                        padding: EdgeInsets.all(20),
                        child: ItemIndicator(icon: IconlyBroken.paper, text: 'No notes added'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      ),
    );
  }
}