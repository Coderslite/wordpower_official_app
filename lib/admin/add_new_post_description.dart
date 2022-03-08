import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddNewPostDescription extends StatefulWidget {
  final List<XFile> allSelectedImages;
  const AddNewPostDescription({Key key, this.allSelectedImages})
      : super(key: key);

  @override
  _AddNewPostDescriptionState createState() => _AddNewPostDescriptionState();
}

class _AddNewPostDescriptionState extends State<AddNewPostDescription> {
  var imageCollection = [];
  String url = "";
  String _message = "";
  File singleImage;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  bool isUploading = false;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.black;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Add post description",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  onChanged: (value) {
                    setState(() {
                      _message = value;
                    });
                  },
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{20,}$');
                    if (value.isEmpty) {
                      return "This field cannot be empty";
                    }
                    if (!regex.hasMatch(value)) {
                      return ("description is too small");
                    }
                    return null;
                  },
                  maxLines: null,
                  style: const TextStyle(color: Colors.white60),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.4)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.4)),
                    ),
                    hintText: "Enter post Description",
                    hintStyle: const TextStyle(color: Colors.white24),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  const Text(
                    "Upload to your story",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                child: Image.file(
                  File(widget.allSelectedImages[0].path),
                  fit: BoxFit.cover,
                ),
              ),
              isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        uploadPost(widget.allSelectedImages,
                            _descriptionController.text);
                      },
                      child: const Text("Upload post"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  uploadPost(allSelectedImages, String description) {
    setState(() {
      isUploading = true;
    });
    uploadImage(allSelectedImages, description).then((value) {
      print(imageCollection);
      print(description);
      addPost(description);
    });
  }

  Future uploadImage(allSelectedImages, description) async {
    int i = 1;
    for (var img in allSelectedImages) {
      setState(() {
        val = i / allSelectedImages.length;
      });
      singleImage = File(img.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('post/')
          .child('$description/$i');
      firebase_storage.UploadTask task = ref.putFile(singleImage);
      firebase_storage.TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      imageCollection.add(url);
      i++;
    }
  }

  addPost(description) {
    // var imgUrl = imageCollection;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("post").doc();
    // Map testing = {
    //   "it": "eat",
    //   "so": "sow",
    // };
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    Map<String, dynamic> addPost = {
      "description": description,
      "postId": documentReference.id,
      "date": formatted,
      "time": now.microsecondsSinceEpoch.toString(),
      'imageUrl': imageCollection.toList(),
      "postLiked": [],
    };
    documentReference.set(addPost).whenComplete(() {
      Fluttertoast.showToast(msg: "Upload Successful");
      print('Upload Successful');
      setState(() {
        isUploading = false;
        _message = "";
      });
    }).catchError((e) {
      setState(() {
        isUploading = false;
      });
      print(e.message);
    });
  }
}
