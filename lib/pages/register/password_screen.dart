import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordpower_official_app/pages/register/confirm_password_screen.dart';

class PasswordScreen extends StatefulWidget {
  final String email;
  const PasswordScreen({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = new TextEditingController();
  // firebase
  final _auth = FirebaseAuth.instance;

  bool isChecked = false;
  bool isEmpty = false;
  bool _isObscure = true;

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
                    "Create a Password",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, right: 15, left: 15, bottom: 0),
                    child: TextFormField(
                      controller: passwordController,
                      // keyboardType: TextInputType.emailAddress,
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
                  SizedBox(height: 10),
                  Container(
                    width: size.width - 70,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        passwordCreate(
                          widget.email,
                          passwordController.text,
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
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

  void passwordCreate(String email, String password) async {
    if (_formKey.currentState.validate()) {
      // Fluttertoast.showToast(msg: email);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfirmPasswordScreen(
                password: password,
                email: email,
              )));
    }
  }
}
