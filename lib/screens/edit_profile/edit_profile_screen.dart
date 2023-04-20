import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';
import 'package:wellfreshlogin/consts/consts.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var user = FirebaseFirestore.instance.collection(usersCollection);
  String? selectedGender;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var phoneNumberController = TextEditingController();

  var biographyController = TextEditingController();
  var specialtyController = TextEditingController();

  List<String> specialties = [];
  File? imageFile;

  void pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile', backButton: true, color: surfaceColor, scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomNavBar(
        title: 'Save Changes',
        icon: IconlyBroken.editSquare,
        action: () async {
          if (_formkey.currentState!.validate()) {
            if (imageFile != null) {
              String imageName = FirebaseAuth.instance.currentUser!.uid;
              Reference storageReference =
              FirebaseStorage.instance.ref().child('userImages/$imageName');
              UploadTask uploadTask = storageReference.putFile(imageFile!);
              TaskSnapshot taskSnapshot = await uploadTask;
              String downloadUrl = await taskSnapshot.ref.getDownloadURL();

              await user.doc(FirebaseAuth.instance.currentUser!.uid).update({
                'firstname': firstNameController.text,
                'lastname': lastNameController.text,
                'gender': selectedGender,
                'email': emailController.text,
                'address': addressController.text,
                'phoneNumber': phoneNumberController.text,
                'biography': biographyController.text,
                'imageUrl': downloadUrl,
              });
            }
            else {
              await user.doc(FirebaseAuth.instance.currentUser!.uid).update({
                'firstname': firstNameController.text,
                'lastname': lastNameController.text,
                'gender': selectedGender,
                'email': emailController.text,
                'address': addressController.text,
                'phoneNumber': phoneNumberController.text,
                'biography': biographyController.text,
              });
            }
            Future.delayed(Duration.zero).then((value) {
              Navigator.pop(context);
              FloatingSnackBar.show(context, 'Account details updated successfuly!');
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirestoreServices.getUser(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                else {
                  var data = snapshot.data!.data();

                  firstNameController.text = data!['firstname'];
                  lastNameController.text = data['lastname'];
                  emailController.text = data['email'];
                  addressController.text = data['address'] ?? '';
                  phoneNumberController.text = data['phoneNumber'] ?? '';
                  selectedGender = data['gender'];

                  if (data['role'] == 'Doctor') {
                    biographyController.text = data['biography'] ?? '';

                    specialties = [];
                    List<dynamic> specialtiesTmp = data['specialties'] ?? [];
                    specialties.addAll(specialtiesTmp.cast<String>());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: pickImage,
                          child: CircleAvatar(
                            backgroundColor: tertiaryColor,
                            backgroundImage: imageFile != null ? FileImage(imageFile!)
                            : NetworkImage(data['imageUrl'] ?? defAvatar) as ImageProvider,
                            radius: 90,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      CustomTextField(
                        title: 'First name',
                        hintText: 'First name',
                        prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
                        controller: firstNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: 'Last name',
                        hintText: 'Last name',
                        prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
                        controller: lastNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButtonFormField<String>(
                            value: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select your gender';
                              }
                              return null;
                            },
                            items: [
                              'Male',
                              'Female',
                              'Other',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownColor: cardColor,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: secondaryTextColor,
                              ),
                              hintText: 'Gender',
                              fillColor: cardColor,
                              filled: true,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                              prefixIcon: const Icon(
                                IconlyBroken.profile,
                                color: tertiaryTextColor,
                              ),
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        title: 'Email addres',
                        hintText: 'Email address',
                        prefixIcon: const Icon(IconlyBroken.message, color: tertiaryTextColor),
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: 'Address',
                        hintText: 'Address',
                        prefixIcon: const Icon(IconlyBroken.home, color: tertiaryTextColor),
                        controller: addressController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: 'Phone number',
                        hintText: 'Phone number',
                        prefixIcon: const Icon(IconlyBroken.call, color: tertiaryTextColor),
                        controller: phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),

                      if (data['role'] == 'Doctor') ...[
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Biography',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomTextField(
                          title: 'Biography',
                          hintText: 'Briefly describe yourself',
                          prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
                          controller: biographyController,
                          lines: 5,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            'This will appear in the doctor\'s information screen when viewed as a patient.',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: tertiaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Specialties',
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: specialties.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 40,
                                padding: const EdgeInsets.only(left: 24, right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (index < specialties.length) ...[
                                      Text(
                                        specialties[index],
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              specialtyController.text = specialties[index];
                                              showSpecialtiesDialog(context, index, 'edit');
                                            },
                                            icon: const Icon(IconlyBroken.editSquare, color: accentColor),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showSpecialtiesDialog(context, index, 'delete');
                                            },
                                            icon: const Icon(IconlyBroken.delete, color: errorColor),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      Expanded(
                                        child: ListTile(
                                          onTap: () {
                                            specialtyController.text = '';
                                            showSpecialtiesDialog(context, index, 'add');
                                          },
                                          leading: const Icon(
                                            IconlyBroken.addUser,
                                            color: accentTextColor,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                          title: Text(
                                            'Add specialty',
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            'The first item in your list of specialties will be displayed in the main screen when viewed as a patient.',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: tertiaryTextColor,
                            ),
                          ),
                        ),
                      ]
                    ],
                  );
                }
              }
            ),
          ),
        ),
      ),
    );
  }

  showSpecialtiesDialog(BuildContext context, index, action) {
    AlertDialog alert = AlertDialog(
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24))
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      title: Text(
        action == 'add' ? 'Add specialty'
        : action == 'edit' ? 'Edit specialty'
        : 'Remove specialty',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: secondaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          action != 'delete' ? CustomTextField(
            title: 'Specialty',
            hintText: 'Specialty',
            prefixIcon: const Icon(IconlyBroken.paper, color: tertiaryTextColor),
            controller: specialtyController,
          ) : Text(
            'Are you sure you want to delete this specialty?',
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
                  user.doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                    'specialties': FieldValue.arrayUnion([specialtyController.text])
                  }).then((value) {
                    setState(() {
                      specialties.add(specialtyController.text);
                    });
                  });
                  Navigator.pop(context);
                } : action == 'edit' ? () {
                  setState(() {
                    specialties[index] = specialtyController.text;
                  });
                  user.doc(FirebaseAuth.instance.currentUser!.uid).update({
                    'specialties': specialties,
                  });
                  Navigator.pop(context);
                } : () {
                  setState(() {
                    specialties.removeAt(index);
                  });
                  user.doc(FirebaseAuth.instance.currentUser!.uid).update({
                    'specialties': specialties,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
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