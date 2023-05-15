import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';
import 'package:wellfresh/screens/screens.dart';
import 'package:wellfresh/consts/consts.dart';
import 'package:wellfresh/services/firebase_services.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Patients', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: accentTextColor,
            unselectedLabelColor: primaryTextColor,
            indicatorColor: accentColor,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ListPatientsByStatus(status: 'ongoing'),
                ListPatientsByStatus(status: 'done'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListPatientsByStatus extends StatelessWidget {
  final String status;

  const ListPatientsByStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: FirestoreServices.getAppointments(userId, status),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (snapshot.data!.docs.isEmpty) {
                return const ItemIndicator(
                  icon: IconlyBroken.calendar,
                  text: 'No appointments found',
                );
              }
              else {
                var data = snapshot.data!.docs;

                // Sort the appointments by date and time
                data.sort((a, b) {
                  Map<String, dynamic> appointmentA = a.data() as Map<String, dynamic>;
                  Map<String, dynamic> appointmentB = b.data() as Map<String, dynamic>;

                  int compareMonth = appointmentA['month'].compareTo(appointmentB['month']);
                  if (compareMonth != 0) {
                    return compareMonth;
                  }

                  int compareDay = appointmentA['day'].compareTo(appointmentB['day']);
                  if (compareDay != 0) {
                    return compareDay;
                  }

                  return appointmentA['time'].compareTo(appointmentB['time']);
                });

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
                          customName: GetPatientName(documentId: appointment['patientId']),
                          description: '${appointment['month']} ${appointment['day']}',
                          subtext: appointment['time'],
                          imageUrl: appointment.containsKey('imageUrl') ? appointment['imageUrl'] : defAvatar,
                          customImage: GetPatientImage(documentId: appointment['patientId']),
                          action: () => Get.to(() => AppointmentDetailsDoctorScreen(
                            appointmentId: appointmentId,
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
    );
  }
}
