import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/admin/admin_home.dart';
import 'package:wordpower_official_app/pages/register/register_screen.dart';
import 'package:wordpower_official_app/pages/root_app.dart';
// import 'package:wordpower_official_app/theme/colors.dart';
import 'package:wordpower_official_app/pages/forget_password/forget_password.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                SizedBox(
                  width: 100,
                  child: Image.asset("images/logo.png"),
                ),
                const Text(
                  "Wordpower Ministry",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "RedHatDisplay",
                  ),
                ),
                const SizedBox(
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "RedHatDisplay",
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        color: Colors.white38,
                        fontFamily: "RedHatDisplay",
                      ),
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
                        fontFamily: "RedHatDisplay",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 40, right: 40),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value.isEmpty) {
                        return ("Please enter your password");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Please Enter Valid Password(Min, 6 Character");
                      }
                      return null;
                    },
                    autofocus: false,
                    obscureText: _isObscure,
                    onSaved: (value) {
                      passwordController.text = value;
                    },
                    style:const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "RedHatDisplay",
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Colors.white38,
                        fontFamily: "RedHatDisplay",
                      ),
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
                const SizedBox(
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
                  child: SizedBox(
                    width: double.infinity,
                    child: _isloading
                        ? Center(
                            child: Column(
                              children: const [
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
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "RedHatDisplay",
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: size.width - 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot your login information ?",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontFamily: "RedHatDisplay",
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return const ForgetPassword();
                          }));
                        },
                        child:const Text(
                          "Click here",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "RedHatDisplay",
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  child:const Text(
                    "Create a new Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "RedHatDisplay",
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const RegisterScreen();
                    }));
                  },
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
