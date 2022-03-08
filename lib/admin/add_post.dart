import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPost extends StatefulWidget {
  const AddPost({Key key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File singleImage;
  final singlePicker = ImagePicker();
  final multiPicker = ImagePicker();
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Add Post",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: () => getSingleImage(),
                child: singleImage == null
                    ? Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                            border: Border.all(color: Colors.white)),
                        height: 100,
                        width: 100,
                        child: Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                            border: Border.all(color: Colors.white)),
                        height: 100,
                        width: 100,
                        child: Image.file(
                          singleImage,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Admin Profile",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.2),
              ),
              Text(
                "Add the images you want to upload",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getSingleImage() async {
    final pickedImage =
        await singlePicker.pickImage(source: (ImageSource.gallery));
    setState(() {
      if (pickedImage != null) {
        singleImage = File(pickedImage.path);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('test/how are you');
        final uploadTask = ref.putFile(singleImage);
        final taskSnapshot = uploadTask.whenComplete(
          () {
            print("Successfully added to firebase storage");
          },
        );
      } else {
        print("No image is selected");
      }
    });
  }

  Future getMultiImage() async {
    final List<XFile> selectedImages = await multiPicker.pickMultiImage();
    setState(() {
      if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages);
      } else {
        print("No image is selected");
      }
    });
  }
}
