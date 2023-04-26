import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/consts/consts.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final _formkey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var user = FirebaseFirestore.instance.collection(usersCollection);
  var autofillOpacity = 0.35;

  bool loading = false;
  bool enableAutofill = false;

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var zipCodeController = TextEditingController();

  void getDeliveryDetails() async {
    DocumentSnapshot snapshot = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('delivery_details')) {
        setState(() {
          enableAutofill = data['delivery_details'][0];
          addressController.text = data['delivery_details'][1];
          cityController.text = data['delivery_details'][2];
          stateController.text = data['delivery_details'][3];
          zipCodeController.text = data['delivery_details'][4];

          if (enableAutofill) {
            autofillOpacity = 1.0;
          }
        });
      }
    }
  }

  @override
  void initState() {
    getDeliveryDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Delivery Details', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Save Details',
        icon: IconlyBroken.paper,
        action: () async {
          if (_formkey.currentState!.validate()) {
            setState(() { loading = true; });
            var detailsList = [];

            detailsList.add(enableAutofill);
            detailsList.add(addressController.text);
            detailsList.add(cityController.text);
            detailsList.add(stateController.text);
            detailsList.add(zipCodeController.text);

            await user.doc(FirebaseAuth.instance.currentUser!.uid).update({
              'delivery_details': detailsList,
            });

            Future.delayed(Duration.zero).then((value) {
              FloatingSnackBar.show(context, 'Delivery details updated successfully');
              setState(() { loading = false; });
            });
          }
        },
        loadingIndicator: loading,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [containerShadow],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enable auto-fill of delivery details',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                      Switch(
                        value: enableAutofill,
                        onChanged: (value) {
                          setState(() {
                            enableAutofill = !enableAutofill;

                            if (enableAutofill) {
                              autofillOpacity = 1.0;
                            }
                            else {
                              autofillOpacity = 0.35;
                            }
                          });
                        }
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Fill out your shipping delivery information so you don\'t have to re-enter it every time you order.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: tertiaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Delivery Details',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedOpacity(
                  opacity: autofillOpacity,
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      CustomTextField(
                        title: 'Address',
                        hintText: 'Address',
                        prefixIcon: const Icon(IconlyBroken.home, color: tertiaryTextColor),
                        controller: addressController,
                        enabled: enableAutofill,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: 'City',
                        hintText: 'City',
                        prefixIcon: const Icon(IconlyBroken.location, color: tertiaryTextColor),
                        controller: cityController,
                        enabled: enableAutofill,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: 'State',
                        hintText: 'State',
                        prefixIcon: const Icon(IconlyBroken.location, color: tertiaryTextColor),
                        controller: stateController,
                        enabled: enableAutofill,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: 'ZIP Code',
                        hintText: 'ZIP Code',
                        prefixIcon: const Icon(IconlyBroken.location, color: tertiaryTextColor),
                        controller: zipCodeController,
                        enabled: enableAutofill,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}