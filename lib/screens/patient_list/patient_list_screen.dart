import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

import 'package:wellfreshlogin/patient_details.dart';

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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: FirestoreServices.getAppointments(status),
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
    );
  }
}