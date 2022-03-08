import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddYoutubeVideo extends StatefulWidget {
  const AddYoutubeVideo({Key key}) : super(key: key);

  @override
  _AddYoutubeVideoState createState() => _AddYoutubeVideoState();
}

class _AddYoutubeVideoState extends State<AddYoutubeVideo> {
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Add Youtube Video"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Center(
                  child: Text(
                    "Add youtube video using video ID",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                TextFormField(
                  controller: _linkController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter the video Id";
                    }
                    if (utube.hasMatch(_linkController.text)) {
                      return "Not Valid";
                    }
                  },
                  onSaved: (value) {
                    _linkController.text = value;
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Enter Video Link e.g '0SVA4PY951Y' ",
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                    ),
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
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter the video Id";
                    }
                  },
                  onSaved: (value) {
                    _titleController.text = value;
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Enter Youtube Video link",
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                    ),
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
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter the video Id";
                    }
                  },
                  onSaved: (value) {
                    _descriptionController.text = value;
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Enter Video Description",
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                    ),
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
                  ),
                ),
                _isloading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          addYoutubeVideo(
                            _linkController.text,
                            _titleController.text,
                            _descriptionController.text,
                          );
                        },
                        child: const Text("Upload Video"),
                        style: const ButtonStyle(),
                      ),
              ],
            )),
      ),
    );
  }

  addYoutubeVideo(
    String link,
    String title,
    String description,
  ) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("youtube_videos").doc(title);
      Map<String, String> addVideo = {
        "name": title,
        "link": link,
        "description": description
      };
      documentReference.set(addVideo)
          // ignore: avoid_print
          .whenComplete(() {
        setState(() {
          _isloading = false;
          Fluttertoast.showToast(msg: "Upload Successful");
        });
      });
    }
  }
}
