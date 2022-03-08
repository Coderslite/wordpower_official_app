import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordpower_official_app/admin/add_new_post_description.dart';

class AddNewPost extends StatefulWidget {
  const AddNewPost({Key key}) : super(key: key);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  //  File? singleImage;
  // final singlePicker = ImagePicker();
  final multiPicker = ImagePicker();
  List<XFile> images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Add New Post"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Select image",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: InkWell(
                onTap: () => getMultiImage(),
                child: GridView.builder(
                  itemCount: images.isEmpty ? 1 : images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => Container(
                    child: images.isEmpty
                        ? Icon(
                            CupertinoIcons.camera,
                            color: Colors.white,
                          )
                        : Image.file(
                            File(images[index].path),
                            fit: BoxFit.cover,
                          ),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.5))),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AddNewPostDescription(allSelectedImages: images);
                  }));
                },
                child: const Text("Next"))
          ],
        ),
      ),
    );
  }

  Future getMultiImage() async {
    final List<XFile> selectedImages = await multiPicker.pickMultiImage();
    setState(() {
      if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages);
      } else {
        Fluttertoast.showToast(msg: "No Image selected");
        // print("No image is selected");
      }
    });
  }
}
