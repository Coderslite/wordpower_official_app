import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordpower_official_app/widget/components/settings_component/account/gender.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key key}) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  bool isPreview = false;
  bool isUploading = false;
  final format = DateFormat("yyyy-MM-dd");
  File singleImage;
  final singlePicker = ImagePicker();
  User user = FirebaseAuth.instance.currentUser;
  String url = "";
  String currentImage =
      (FirebaseAuth.instance.currentUser.photoURL).toString();
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Personal Information"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: users.doc(user.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              );
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text(
                "Document does not exist",
                style: TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 15,
                  right: 15,
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => getSingleImage(user.uid),
                            child: isPreview == false
                                ? Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.black,
                                        border:
                                            Border.all(color: Colors.white)),
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      // data["profileImage"],
                                      currentImage,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.black,
                                            border: Border.all(
                                                color: Colors.white)),
                                        height: 100,
                                        width: 100,
                                        child: Image.file(
                                          singleImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      isUploading
                                          ? CircularProgressIndicator()
                                          : ElevatedButton(
                                              onPressed: () {
                                                uploadImage(user.uid);
                                              },
                                              child: Text("Update Image"),
                                            ),
                                    ],
                                  ),
                          ),
                          Text(
                            "Provide your personal information below, \n so that the man of God can identify you.\n It will not be displayed publicly",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Email Address",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: data['email'],
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.4)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "+2348145108521",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.4)),
                          prefixIcon: Icon(
                            Icons.call,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Gender",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.person,
                                    color: Colors.white.withOpacity(0.7)),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return GenderScreen();
                                    }));
                                  },
                                  child: Text(
                                    "Gender",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.4)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Birthday",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DateTimeField(
                        decoration: InputDecoration(
                          hintText: "05/May/1990",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.4)),
                          prefixIcon: Icon(
                            Icons.cake,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 0.3,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: Text("Update Information"))
                    ],
                  ),
                ),
              );
            }
            return Text("loading");
          },
        ),
      ),
    );
  }

  Future getSingleImage(userId) async {
    final pickedImage =
        await singlePicker.pickImage(source: (ImageSource.gallery));
    setState(
      () {
        if (pickedImage != null) {
          isPreview = true;
          singleImage = File(pickedImage.path);
          uploadImage(userId);
        } else {
          Fluttertoast.showToast(msg: "No image is selected");
        }
      },
    );
  }

  Future uploadImage(userId) async {
    setState(() {
      isUploading = true;
    });
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('users/')
        .child('$userId / $userId');
    firebase_storage.UploadTask task = ref.putFile(singleImage);
    firebase_storage.TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    task.then((p0) {
      updateFirestoreImage(userId);
    });
  }

  updateFirestoreImage(userId) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(userId);
    documentReference.update({"profileImage": url}).whenComplete(() {
      setState(() {
        isPreview = false;
        isUploading = false;
      });
      Fluttertoast.showToast(msg: "Profile Image Updated Successfully");
      user.reload();
      FirebaseAuth.instance.currentUser
          .updatePhotoURL(url)
          .whenComplete(() async {
        setState(() {
          currentImage = url;
        });
        await user.reload();
        // ignore: await_only_futures
        user = await user;
      });
    }).catchError((e) {
      setState(() {
        isUploading = false;
        isPreview = false;
      });
      Fluttertoast.showToast(msg: e.message);
    });
  }
}
