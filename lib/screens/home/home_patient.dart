import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/screens/appointment/appointment_screen.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';

class PatientModule extends StatefulWidget {
  final String firstname;

  const PatientModule({
    super.key,
    required this.firstname,
  });

  @override
  State<PatientModule> createState() => _PatientModuleState();
}

class _PatientModuleState extends State<PatientModule> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = ScrollController();

  late Future<QuerySnapshot> doctorsList;

  Color _barColor = accentColor;
  Color _barfColor = Colors.white;
  bool _fadeTitle = false;

  @override
  void initState() {
    super.initState();
    doctorsList = FirestoreServices.getUsersByRole('Doctor');
    
    _controller.addListener(() {
      if (_controller.position.pixels > 270) {
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
        title: 'Doctors',
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
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
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
                      'Hi, ${widget.firstname}!',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: fadeTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Let\'s find your top doctor!',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: invertTextColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomTextField(
                      hintText: 'Search here...',
                      prefixIcon: Icon(
                        IconlyBroken.search,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Doctors',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                  future: doctorsList,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: RefreshProgressIndicator());
                    }
                    else if (snapshot.data!.docs.isEmpty) {
                      return const ItemIndicator(
                        icon: IconlyBroken.user2,
                        text: 'No doctors found',
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
                          DocumentSnapshot doctorTmp = data[index];
                          Map<String, dynamic> doctor = doctorTmp.data() as Map<String, dynamic>;
                          String doctorId = data[index].id;
        
                          return Column(
                            children: [
                              PersonCard(
                                name: doctor['firstname'] + ' ' + doctor['lastname'],
                                description: doctor.containsKey('specialties') ? doctor['specialties'][0] : 'N/A',
                                imageUrl: doctor.containsKey('imageUrl') ? doctor['imageUrl'] : defAvatar,
                                rating: 4.8,
                                action: () => Get.to(() => AppointmentScreen(docId: doctorId)),
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
    QuerySnapshot doctors = await FirestoreServices.getUsersByRole('Doctor');
    setState(() {
      doctorsList = Future.value(doctors);
    });
  }
}
