import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageForm extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  const MessageForm({Key key, this.onSubmit}) : super(key: key);

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _controller = TextEditingController();
  String _message = "";
  void onPressed() {
    widget.onSubmit(_message);
    setState(() {
      _message = "";
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              minLines: 1,
              maxLines: 5,
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Type a Message",
                hintStyle: TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          RawMaterialButton(
            fillColor: _message == null || _message.isEmpty
                ? Colors.grey
                : Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _message == null || _message.isEmpty ? null : onPressed();
            },
            child: Icon(
              CupertinoIcons.location_fill,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
