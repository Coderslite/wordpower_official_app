import 'package:flutter/material.dart';
import 'package:wordpower_official_app/pages/widget/video_screen.dart';

class VideoDetail extends StatefulWidget {
  const VideoDetail({Key key}) : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: const Text("Video Detail"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              borderRadius: BorderRadius.circular(20),
              // color:Colors.red,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    saved = !saved;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    saved
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                saved = !saved;
                              });
                            },
                            icon: const Icon(Icons.favorite_rounded),
                            color: Colors.red,
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                saved = !saved;
                              });
                            },
                            icon: const Icon(Icons.favorite_outline_outlined),
                            color: Colors.red,
                          ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // const Text(
                    //   "Save Video",
                    //   style: TextStyle(fontFamily: "RedHatDisplay"),
                    // ),
                  ],
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text(
                      "Watch now",
                      style: TextStyle(fontFamily: "RedHatDisplay"),
                    ),
                    Icon(Icons.play_arrow_outlined)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.5,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/image2.jpg"),
                            fit: BoxFit.cover)),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return VideoScreen();
                        }));
                      },
                      icon: Icon(
                        Icons.play_arrow,
                        size: 50,
                      ),
                    )),
                // Positioned(
                //   left: MediaQuery.of(context).size.width / 2.2,
                //   top: MediaQuery.of(context).size.height / 9,
                //   child: const Icon(
                //     Icons.play_arrow_outlined,
                //     size: 45,
                //   ),
                // ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 9,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Easter Sunday Service",
                            style: TextStyle(
                                fontFamily: "RedHatDisplay",
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            "Easter Sunday Service",
                            style: TextStyle(
                                fontFamily: "RedHatDisplay", fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        "Minister: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: "RedHatDisplayRegular",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Apostle Mike Freedman",
                        style: TextStyle(fontFamily: "RedHatDisplay"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Duration: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: "RedHatDisplayRegular",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "5 minutes",
                        style: TextStyle(fontFamily: "RedHatDisplay"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Upload Date: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: "RedHatDisplayRegular",
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "5-April-2022",
                        style: TextStyle(
                          fontFamily: "RedHatDisplay",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
