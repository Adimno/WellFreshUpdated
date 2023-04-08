import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedGender;
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot snapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _firstNameController.text =
        data.containsKey('firstname') ? data['firstname'] : '';
        _lastNameController.text =
        data.containsKey('lastname') ? data['lastname'] : '';
        _emailController.text =
        FirebaseAuth.instance.currentUser!.email!;
        _addressController.text =
        data.containsKey('address') ? data['address'] : '';
        _selectedGender =
        data.containsKey('gender') ? data['gender'] : null; // set selected gender value
        _phoneNumberController.text =
        data.containsKey('phoneNumber') ? data['phoneNumber'] : '';
      });
    }
  }

  void updateUserData() async {
    if (_formKey.currentState!.validate()) {
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'firstname': _firstNameController.text.trim(),
        'lastname': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'gender': _selectedGender,
        'phoneNumber': _phoneNumberController.text.trim(),
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: ['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateUserData,
                  child:
                  Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
