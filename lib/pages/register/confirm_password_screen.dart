import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/models/register_model/user_model.dart';
import 'package:wordpower_official_app/pages/root_app.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;
  final String password;
  const ConfirmPasswordScreen(
      {Key key,this.email,this.password})
      : super(key: key);

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordConfirmController =
      new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;
  bool _isObscure = true;
  bool _isloading = false;
  bool isChecked = false;
  bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    "Confirm Password",
                    style: TextStyle(color: Colors.white, fontSize: 20,
          fontFamily: "RedHatDisplay",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, right: 15, left: 15, bottom: 0),
                    child: TextFormField(
                      controller: passwordConfirmController,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value.isEmpty) {
                          return ("Please enter your password");
                        }
                        if (passwordConfirmController.text != widget.password) {
                          return ("Passwords not are thesame");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Please Enter Valid Password(Min, 6 Character");
                        }
                        return null;
                      },
                      autofocus: false,
                      obscureText: _isObscure,
                      onSaved: (value) {
                        passwordConfirmController.text = value;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 18,
          fontFamily: "RedHatDisplay",
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white38,
          fontFamily: "RedHatDisplay",
                        ),
                        prefixIcon: Icon(
                          Icons.vpn_key_outlined,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
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
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                        Text(
                          "Remember Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
          fontFamily: "RedHatDisplay",

                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: size.width - 70,
                    height: 45,
                    child: _isloading
                        ? Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              signUp(
                                  widget.email, passwordConfirmController.text);
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white,
          fontFamily: "RedHatDisplay",
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addUser(String email, String password) {
    User user = _auth.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    Map<String, String> addUser = {
      "email": email,
      "password": password,
      "uid": user.uid,
      "role": "user",
      "profileImage":
          "https://thewebinarvet-wordpress.s3.amazonaws.com/uploads/2018/04/profile-pic-300x300.png"
    };
    documentReference.set(addUser)
        // ignore: avoid_print
        .whenComplete(() {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return RootApp();
      }));
    });
  }

  signUp(String email, String password) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((e) {
        addUser(email, password);
        setState(() {
          _isloading = false;
        });
      }).catchError((e) {
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(msg: e.message);
      });
      // ignore: avoid_print
    }
  }
}
