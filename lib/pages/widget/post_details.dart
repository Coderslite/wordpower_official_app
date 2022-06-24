import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordpower_official_app/constant/comment.dart';
import 'package:wordpower_official_app/pages/widget/appbar.dart';
import 'package:wordpower_official_app/pages/widget/post_image_view.dart';
import 'package:wordpower_official_app/theme/colors.dart';

class PostDetails extends StatefulWidget {
  final String id;
  final String postImg;
  final String caption;
  const PostDetails(
      {Key key,
      this.id,
      this.postImg,
      this.caption})
      : assert(id != null),
        assert(postImg != null),
        assert(caption != null),
        super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.restoreSystemUIOverlays();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        appBar: getAppBar(0,context),
        backgroundColor: Colors.black,
        bottomSheet: getBottomNav(size: size),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  child: Hero(
                    tag: widget.id,
                    child: Image.asset(widget.postImg),
                  ),
                  onTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(
                            postImg: widget.postImg, id: widget.id);
                      }))),
              // onVerticalDragDown: (details)=> Navigator.pop(context),
              // onHorizontalDragStart: (details) => Navigator.pop(context),
              Container(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.caption,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Comments",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 45),
                child: Column(
                  children: List.generate(comment.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              comment[index]['image']),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Container(
                                      width: size.width - 150,
                                      child: RichText(
                                        text: TextSpan(
                                          text: comment[index]['name'],
                                          children: [
                                            TextSpan(text: " "),
                                            TextSpan(
                                                text: comment[index]['message'], style: TextStyle(color: Colors.white.withOpacity(0.7))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 10, bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "4d",
                                style:
                                    TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                              SizedBox(width: 30,),
                              Text(
                                "2 like",
                                style:
                                    TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                              SizedBox(width: 30,),
                              Text(
                            "reply",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

getBottomNav({Size size}) {
  return Container(
    color: Colors.black,
    child: Row(
      children: [
        Row(
          children: [
            SizedBox(width: 10),
            Container(
              width: size.width - 75,
              height: 55,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add Comment",
                    hintStyle: TextStyle(color: white.withOpacity(0.7))),
                style: TextStyle(color: white.withOpacity(0.7)),
              ),
            ),
          ],
        ),
        SizedBox(width:20),
        Text("post", style: TextStyle(color: Colors.white.withOpacity(0.7),))
      ],
    ),
  );
}
