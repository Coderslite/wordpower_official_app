import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordpower_official_app/pages/login/login_screen.dart';
import 'package:wordpower_official_app/pages/root_app.dart';
// import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user = _auth.currentUser;
  _auth.authStateChanges().listen((event) {
    if (user == null) {
      runApp(const Login());
    } else {
      runApp(const HomePage());
    }
  });
}

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordpower Ministry',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordpower Ministry',
      theme: ThemeData.dark(),
      home: const RootApp(),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer(
//         Duration(seconds: 5),
//         () => Navigator.push(context, MaterialPageRoute(builder: (_) {
//               return RootApp();
//             })));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(10.0),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     Padding(
//                       padding: EdgeInsets.only(top: 20.0),
//                     ),
//                     Text(
//                       "Welcome To Our Official Ministry App",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
