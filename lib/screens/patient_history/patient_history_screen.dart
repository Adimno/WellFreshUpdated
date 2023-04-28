import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/consts/consts.dart';
import 'package:wellfresh/services/firebase_services.dart';

class PatientHistoryScreen extends StatefulWidget {
  final String patientId;

  const PatientHistoryScreen({
    required this.patientId,
    super.key,
  });

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Patient\'s History', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirestoreServices.getTargetUser(widget.patientId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            var userData = snapshot.data!.data();
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                          child: userData!.containsKey('imageUrl') ? Image.network(userData['imageUrl'], fit: BoxFit.cover)
                          : Image.asset(defAvatar, fit: BoxFit.cover),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userData['firstname']} ${userData['lastname']}',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: primaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userData['phoneNumber'] ?? 'No phone number',
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
                    const SizedBox(height: 16),
                    Text(
                      'Appointments',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder(
                      future: FirestoreServices.getPatientAppointments(widget.patientId),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        else {
                          var data = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot appointmentTmp = data[index];
                              Map<String, dynamic> appointment = appointmentTmp.data() as Map<String, dynamic>;
                              String doctorName = '';

                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [containerShadow],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${appointment['month']} ${appointment['day']}, ${appointment['year']}',
                                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                  color: primaryTextColor,
                                                ),
                                              ),
                                              Text(
                                                appointment['time'],
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  color: accentTextColor,
                                                ),
                                              ),
                                              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                future: FirestoreServices.getDoctorName(appointment['docId']),
                                                builder: (_, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container(
                                                      width: 100,
                                                      height: 10,
                                                      margin: const EdgeInsets.only(top: 8),
                                                      decoration: BoxDecoration(
                                                        color: tertiaryTextColor,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    var data = snapshot.data!.data();
                                                    doctorName = 'Dr. ${data!['firstname']} ${data['lastname']}';

                                                    return Text(
                                                      doctorName,
                                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                        color: tertiaryTextColor,
                                                      ),
                                                    );
                                                  }
                                                }
                                              ),
                                            ],
                                          ),
                                        ),
                                        ActionButton(
                                          title: 'View Notes',
                                          fontSize: 12,
                                          action: () {
                                            double notesLength = appointment.containsKey('notes') ?
                                            double.parse(appointment['notes'].length.toString()) + 1 : 1;

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: surfaceColor,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(24))
                                                  ),
                                                  title: Text(
                                                    '$doctorName\'s Notes',
                                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: primaryTextColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: SizedBox(
                                                    width: double.maxFinite,
                                                    height: 100 + (42 * notesLength),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        appointment['notes'].length > 0 ? Expanded(
                                                          child: ListView.separated(
                                                            shrinkWrap: true,
                                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                                            itemCount: appointment['notes'].length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              return SizedBox(
                                                                height: 40,
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                      IconlyBroken.paper,
                                                                      color: tertiaryTextColor,
                                                                    ),
                                                                    const SizedBox(width: 16),
                                                                    Expanded(
                                                                      child: Text(
                                                                        appointment['notes'][index],
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
                                                        ) : const Expanded(child: ItemIndicator(icon: IconlyBroken.paper, text: 'No notes available')),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            ActionButton(
                                                              title: 'OK',
                                                              backgroundColor: accentColor,
                                                              foregroundColor: invertTextColor,
                                                              fontSize: 14,
                                                              action: () => Navigator.pop(context),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }
                          );
                        }
                      }
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