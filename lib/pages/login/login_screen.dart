import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/admin/admin_home.dart';
import 'package:wordpower_official_app/pages/register/register_screen.dart';
import 'package:wordpower_official_app/pages/root_app.dart';
// import 'package:wordpower_official_app/theme/colors.dart';
import 'package:wordpower_official_app/widget/login/forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  //form key
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // firebase
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  child: Image.asset("images/logo.png"),
                ),
                Container(
                  child: Text(
                    "Wordpower Ministry",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 40, right: 40),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ("Please enter your email");
                      }
                      // reg expression for email validation
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9,-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("please enter a valid email address");
                      }
                      return null;
                    },
                    autofocus: false,
                    onSaved: (value) {
                      emailController.text = value;
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: Icon(Icons.email_outlined,
                          color: Colors.white.withOpacity(0.4)),
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
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 40, right: 40),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value.isEmpty) {
                        return ("Please enter your password");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Please Enter Valid Password(Min, 6 Character");
                      }
                    },
                    autofocus: false,
                    obscureText: _isObscure,
                    onSaved: (value) {
                      passwordController.text = value;
                    },
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white38),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.vpn_key_outlined,
                        color: Colors.white.withOpacity(0.4),
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
                  height: 20,
                ),
                // Container(
                //   width: size.width - 70,
                //   height: 45,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.blue.withOpacity(0.5)),
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.only(right: 15, left: 15, bottom: 0),
                //     child: Center(
                //       child: Text(
                //         "Login",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    width: double.infinity,
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
                        : Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                            child: MaterialButton(
                              onPressed: () {
                                signIn(emailController.text,
                                    passwordController.text);
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width - 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot your login information ?",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7), fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return ForgetPassword();
                          }));
                        },
                        child: Text(
                          "Click here",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                  child: GestureDetector(
                    child: Text(
                      "Create a new Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return RegisterScreen();
                      }));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    // validate user
    if (_formKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });

      // authenticate user login
      final userAuth = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(msg: e.message);
      });

      // check the role of the user login
      if (userAuth != null) {
        final User user = _auth.currentUser;
        final userID = user.uid;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userID)
            .get()
            .then((DocumentSnapshot snapshot) {
          // store the data for the user in an array
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          if (data['role'] == 'admin') {
            setState(() {
              _isloading = false;
            });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) {
              return const AdminHomeScreen();
            }), (route) => false);
          } else if (data['role'] == 'user') {
            setState(() {
              _isloading = false;
            });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) {
              return const RootApp();
            }), (route) => false);
          }
        }).catchError((e) {
          setState(() {
            _isloading = false;
          });
          Fluttertoast.showToast(msg: e.message);
        });
      }
    }
  }
}
