import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

import 'package:wellfreshlogin/doctorSchedule.dart';
import 'package:wellfreshlogin/patient_details.dart';

class DoctorModule extends StatefulWidget {
  final String firstname;

  const DoctorModule({
    super.key,
    required this.firstname,
  });

  @override
  State<DoctorModule> createState() => _DoctorModuleState();
}

class _DoctorModuleState extends State<DoctorModule> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = ScrollController();

  late Future<QuerySnapshot> appointmentsList;

  Color _barColor = accentColor;
  Color _barfColor = Colors.white;
  bool _fadeTitle = false;

  @override
  void initState() {
    super.initState();
    appointmentsList = FirestoreServices.getAppointments('ongoing');
    
    _controller.addListener(() {
      if (_controller.position.pixels > 160) {
        setState(() {
          _barColor = surfaceColor;
          _barfColor = primaryTextColor;
          _fadeTitle = true;
        });
      }
      else {
        setState(() {
          _barColor = accentColor;
          _barfColor = Colors.white;
          _fadeTitle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: OverlayAppBar(
        title: 'Upcoming Appointments',
        backgroundColor: _barColor,
        foregroundColor: _barfColor,
        fadeTitle: _fadeTitle,
        scaffoldKey: scaffoldKey
      ),
      drawer: const NavigationDrawerWidget(),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  color: accentColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Dr. ${widget.firstname}!',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: fadeTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 54,
                            child: ActionButton(
                              title: 'Schedule',
                              icon: IconlyBroken.calendar,
                              backgroundColor: cardColor,
                              foregroundColor: primaryTextColor,
                              action: () => Get.to(() => DoctorSchedule(docId: FirebaseAuth.instance.currentUser!.uid)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: SizedBox(
                            height: 54,
                            child: ActionButton(
                              title: 'Patients',
                              icon: IconlyBroken.user2,
                              backgroundColor: cardColor,
                              foregroundColor: primaryTextColor,
                              action: () => Get.to(() => const PatientListScreen()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Upcoming Appointments',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                  future: appointmentsList,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: RefreshProgressIndicator());
                    }
                    else if (snapshot.data!.docs.isEmpty) {
                      return const ItemIndicator(
                        icon: IconlyBroken.calendar,
                        text: 'No appointments yet',
                      );
                    }
                    else if (snapshot.hasError) {
                      return const ItemIndicator(
                        icon: IconlyLight.dangerCircle,
                        text: 'Error fetching data',
                      );
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
                          String appointmentId = data[index].id;
        
                          return Column(
                            children: [
                              PersonCard(
                                name: '',
                                customName: GetPatientName(documentId: appointment['patientReference']),
                                description: '${appointment['month']} ${appointment['day']}',
                                subtext: appointment['time'],
                                imageUrl: appointment.containsKey('imageUrl') ? appointment['imageUrl'] : defAvatar,
                                customImage: GetPatientImage(documentId: appointment['patientReference']),
                                action: () => Get.to(() => PatientDetails(
                                  appointmentId: appointmentId,
                                  docId: appointment['docReference'],
                                  patientId: appointment['patientReference'],
                                )),
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
                      );
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    QuerySnapshot appointments = await FirestoreServices.getAppointments('ongoing');
    setState(() {
      appointmentsList = Future.value(appointments);
    });
  }

  getPatientDetails(patientId) {
    FirebaseFirestore.instance.collection(usersCollection).doc(patientId).get().then((data) {
      return data['firstname'];
    });
  }
}