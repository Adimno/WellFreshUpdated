import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  String? _imageUrl;
  File? _imageFile;

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
        _emailController.text = FirebaseAuth.instance.currentUser!.email!;
        _addressController.text =
        data.containsKey('address') ? data['address'] : '';
        _selectedGender =
        data.containsKey('gender') ? data['gender'] : null;
        _phoneNumberController.text =
        data.containsKey('phoneNumber') ? data['phoneNumber'] : '';
        _imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : null;
      });
    }
  }

  void updateUserData() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
        FirebaseStorage.instance.ref().child('userImages/$imageName');
        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
          'firstname': _firstNameController.text.trim(),
          'lastname': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'address': _addressController.text.trim(),
          'gender': _selectedGender,
          'phoneNumber': _phoneNumberController.text.trim(),
          'imageUrl': downloadUrl,
        });
        Navigator.of(context).pop();
      } else {
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
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
  }

  void pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : AssetImage('assets/images/defaultuser.png')
                    as ImageProvider,

                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },

                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
                items: ['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: updateUserData,
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
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

