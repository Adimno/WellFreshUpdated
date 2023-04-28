import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

class AppointmentDetailsDoctorScreen extends StatefulWidget {
  final String patientId;
  final String docId;
  final String appointmentId;

  const AppointmentDetailsDoctorScreen({
    required this.patientId,
    required this.docId,
    required this.appointmentId,
    super.key,
  });

  @override
  State<AppointmentDetailsDoctorScreen> createState() => _AppointmentDetailsDoctorScreenState();
}

class _AppointmentDetailsDoctorScreenState extends State<AppointmentDetailsDoctorScreen> {
  var formkey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var noteController = TextEditingController();
  var user = FirebaseFirestore.instance.collection(usersCollection);

  bool loaded = false;
  String status = 'ongoing';
  List<String> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Appointment Details', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: loaded && status != 'done' ? CustomNavBar(
        title: 'Mark as Done',
        action: () {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                backgroundColor: surfaceColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))
                ),
                title: Text(
                  'Confirm action',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure you want to mark this appointment as done?',
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
                          action: () async {
                            Navigator.pop(context);

                            var appointmentReference = await getAppointmentReference(
                              widget.patientId,
                              widget.appointmentId
                            );

                            setState(() {
                              user.doc(widget.docId)
                              .collection('appointments')
                              .doc(widget.appointmentId)
                              .update({
                                'status': 'done',
                              }).then((value) => {
                                user.doc(widget.patientId)
                                .collection('notifications')
                                .doc()
                                .set({
                                  'type': 'appointment',
                                  'message': 'Your appointment #${widget.appointmentId.substring(0, 7)} has been marked done',
                                  'reference': appointmentReference,
                                  'read': false,
                                  'date': FieldValue.serverTimestamp(),
                                }).then((value) => {
                                  Get.offAll(() => const HomeScreen()),
                                  FloatingSnackBar.show(context, 'The appointment is now marked done'),
                                }),
                              });
                            });
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ) : status == 'done' ?
      Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'This appointment has been closed',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: tertiaryTextColor,
          ),
        ),
      ) : null,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirestoreServices.getAppointment(widget.docId, widget.appointmentId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            var data = snapshot.data!.data();

            notes = [];
            List<dynamic> notesTmp = data!['notes'] ?? [];
            notes.addAll(notesTmp.cast<String>());

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                loaded = true;
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
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirestoreServices.getTargetUser(widget.patientId),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        else {
                          var userData = snapshot.data!.data();

                          return Row(
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
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => Get.to(() => PatientHistoryScreen(patientId: widget.patientId)),
                                    child: Text(
                                      'View appointment history',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        color: accentTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                        itemCount: data['status'] != 'done' ? notes.length + 1 : notes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.only(left: 24, right: 12),
                            child: Row(
                              children: [
                                if (index < notes.length) ...[
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
                                  Row(
                                    children: [
                                      data['status'] != 'done' ? PopupMenuButton(
                                        onSelected: (item) => {
                                          if (item == 0) {
                                            noteController.text = notes[index],
                                            showNotesDialog(context, index, 'edit'),
                                          }
                                          else if (item == 1) {
                                            showNotesDialog(context, index, 'delete'),
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: tertiaryTextColor,
                                        ),
                                        color: cardColor,
                                        shadowColor: boxShadowColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Text(
                                              'Edit note',
                                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                color: primaryTextColor,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              'Delete note',
                                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                color: errorTextColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ) : Container(),
                                    ],
                                  ),
                                ] else ...[
                                  Expanded(
                                    child: ListTile(
                                      onTap: () {
                                        noteController.text = '';
                                        showNotesDialog(context, index, 'add');
                                      },
                                      leading: const Icon(
                                        IconlyBroken.addUser,
                                        color: accentTextColor,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                      title: Text(
                                        'Add note',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: accentTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

  Future<String> getAppointmentReference(userId, appointmentId) async {
    String appointmentReference = '';
    QuerySnapshot snapshot = await FirestoreServices.getAppointmentReference(userId, appointmentId);

    for (var data in snapshot.docs) {
      if (appointmentId == data['appointmentReference']) {
        appointmentReference = data.id;
        break;
      }
    }
    return appointmentReference;
  }

  showNotesDialog(BuildContext context, index, action) {
    AlertDialog alert = AlertDialog(
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24))
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      title: Text(
        action == 'add' ? 'Add note'
        : action == 'edit' ? 'Edit note'
        : 'Remove note',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            action != 'delete' ? CustomTextField(
              title: 'Note',
              hintText: 'Note',
              prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
              controller: noteController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ) : Text(
              'Are you sure you want to delete this note?',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ActionButton(
                  title: 'Cancel',
                  backgroundColor: Colors.transparent,
                  foregroundColor: accentTextColor,
                  fontSize: 14,
                  action: () => Navigator.pop(context),
                ),
                ActionButton(
                  title: action == 'add' ? 'Add'
                  : action == 'edit' ? 'Update'
                  : 'Delete',
                  backgroundColor: action != 'delete' ? accentColor
                  : errorColor,
                  fontSize: 14,
                  action: action == 'add' ? () {
                    if (formkey.currentState!.validate()) {
                      user.doc(widget.docId).collection('appointments').doc(widget.appointmentId).update({
                        'notes': FieldValue.arrayUnion([noteController.text])
                      }).then((value) {
                        setState(() {
                          notes.add(noteController.text);
                        });
                      });
                      Navigator.pop(context);
                    }
                  } : action == 'edit' ? () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        notes[index] = noteController.text;
                      });
                      user.doc(widget.docId).collection('appointments').doc(widget.appointmentId).update({
                        'notes': notes,
                      });
                      Navigator.pop(context);
                    }
                  } : () {
                    setState(() {
                      notes.removeAt(index);
                    });
                    user.doc(widget.docId).collection('appointments').doc(widget.appointmentId).update({
                      'notes': notes,
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}