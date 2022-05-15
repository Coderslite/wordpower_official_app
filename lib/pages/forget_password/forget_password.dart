import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
        child: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Reset Your Password",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Enter the Email Address you used in registering the account",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: size.width - 70,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.5)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, right: 15, left: 15, bottom: 0),
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width - 70,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Verify Email",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width - 270,
                      child: Container(
                        color: Colors.white,
                        height: 0.15,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "OR",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: size.width - 270,
                      child: Container(
                        color: Colors.white,
                        height: 0.15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.facebook,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: GestureDetector(
                        child: Text(
                          "Login with facebook",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
