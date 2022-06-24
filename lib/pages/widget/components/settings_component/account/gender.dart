import 'package:flutter/material.dart';

enum SingingCharacter { lafayette, jefferson }

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  SingingCharacter _character = SingingCharacter.lafayette;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
        ),
        title: Text("Gender"),
        backgroundColor: Colors.black,
        actions: [
          Icon(
            Icons.verified_sharp,
            color: Colors.blue,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.grey, disabledColor: Colors.blue),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Lafayette',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.lafayette,
                    groupValue: _character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Thomas Jefferson',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.jefferson,
                    groupValue: _character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
