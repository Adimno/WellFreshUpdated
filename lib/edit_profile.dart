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
final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');


class _EditProfileState extends State<EditProfile> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  String userRole = 'Doctor';
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _biographyController = TextEditingController();
  final _specialtiesController = TextEditingController();
  String? _selectedGender;
  final _phoneNumberController = TextEditingController();
  String? _imageUrl;
  File? _imageFile;

  List<String> _specialties = [];
  String? _selectedSpecialty;


  @override
  void initState() {
    super.initState();
    getUserData();
    getUserRole().then((role) {
      setState(() {
        userRole = role;
      });
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      if (doc.exists && doc.data()!['role'] == 'Doctor') {
        List<dynamic> specialties = doc.data()!['specialties'];
        _specialties.addAll(specialties.cast<String>());
        setState(() {
          _selectedSpecialty = _specialties[0];
        });
      }
    });

  }


  void getUserData() async {
    DocumentSnapshot snapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {

        _imageUrl = data.containsKey('imageUrl') ? data['imageUrl'] : null;
        _firstNameController.text =
        data.containsKey('firstname') ? data['firstname'] : '';
        _lastNameController.text =
        data.containsKey('lastname') ? data['lastname'] : '';
        _emailController.text = FirebaseAuth.instance.currentUser!.email!;
        _biographyController.text =
        data.containsKey('biography') ? data['biography'] : '';
        _addressController.text =
        data.containsKey('address') ? data['address'] : '';
        _selectedGender =
        data.containsKey('gender') ? data['gender'] : null;
        _phoneNumberController.text =
        data.containsKey('phoneNumber') ? data['phoneNumber'] : '';
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
          'biography': _biographyController.text.trim(),
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
          'biography': _biographyController.text.trim(),
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

  Future<String> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return snapshot['role'];
      }
    }
    return 'unknown';
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
                        : AssetImage('assets/photo.jpg')
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
              if (userRole == 'Doctor')
                TextFormField(
                  controller: _biographyController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Biography',
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
              if (userRole == 'Doctor')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Specialties:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Add New Specialty'),
                                          content: TextFormField(
                                            controller: _specialtiesController,
                                            decoration: InputDecoration(
                                              labelText: 'Specialty',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                String newSpecialty =
                                                _specialtiesController.text.trim();
                                                if (newSpecialty.isNotEmpty) {
                                                  // Save new specialty to Firestore
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                                      .update({
                                                    'specialties': FieldValue.arrayUnion([newSpecialty])
                                                  })
                                                      .then((value) {
                                                    setState(() {
                                                      _specialties.add(newSpecialty);
                                                      _selectedSpecialty = newSpecialty;
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Add New Specialty'),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            if (_specialties.isEmpty)
                              Text('No specialties added yet.'),
                            if (_specialties.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: _specialties.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final specialty = _specialties[index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(specialty),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Edit Specialty'),
                                                    content: TextFormField(
                                                      controller: _specialtiesController..text = specialty,
                                                      decoration: InputDecoration(
                                                        labelText: 'Specialty',
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          String updatedSpecialty = _specialtiesController.text;
                                                          setState(() {
                                                            _specialties[index] = updatedSpecialty;
                                                            if (_selectedSpecialty == specialty) {
                                                              _selectedSpecialty = updatedSpecialty;
                                                            }
                                                          });
                                                          // update specialties in Firestore
                                                          usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                            'specialties': _specialties,
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Save'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () async {
                                              String specialty = _specialties[index];
                                              bool confirmed = await showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Delete Specialty'),
                                                  content: Text('Are you sure you want to delete this specialty?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: Text('Confirm'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirmed) {
                                                await FirebaseFirestore.instance.collection('specialties')
                                                    .doc(specialty)
                                                    .delete();
                                                setState(() {
                                                  _specialties.removeAt(index);
                                                  if (_selectedSpecialty == specialty) {
                                                    _selectedSpecialty = _specialties.isEmpty
                                                        ? null
                                                        : _specialties[0];
                                                  }
                                                });
                                                // delete specialty in Firestore
                                                usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                  'specialties': _specialties,
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedSpecialty = specialty;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
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


