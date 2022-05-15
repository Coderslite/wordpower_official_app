import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordpower_official_app/widget/video_detail.dart';

class VideoCollection extends StatefulWidget {
  @override
  State<VideoCollection> createState() => _VideoCollectionState();
}

class _VideoCollectionState extends State<VideoCollection> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Video Collection"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/dadcover.jpg"),
                            fit: BoxFit.cover)),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 50,
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
                    height: MediaQuery.of(context).size.height / 13,
                    color: Colors.black54,
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
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Recent videos",
              style: TextStyle(
                  fontFamily: "RedHatDisplay",
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return const VideoDetail();
                        }));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3.4,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("images/daddy1.jpg"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.play_arrow),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 18,
                              color: Colors.black54,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Easter Sunday Service",
                                    style: TextStyle(
                                        fontFamily: "RedHatDisplay",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                  Text(
                                    "Easter Sunday Service",
                                    style: TextStyle(
                                        fontFamily: "RedHatDisplay",
                                        fontSize: 5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.4,
                          height: MediaQuery.of(context).size.height / 5,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("images/image1.jpg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.play_arrow),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 18,
                            color: Colors.black54,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Easter Sunday Service",
                                  style: TextStyle(
                                      fontFamily: "RedHatDisplay",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                                Text(
                                  "Easter Sunday Service",
                                  style: TextStyle(
                                      fontFamily: "RedHatDisplay", fontSize: 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.4,
                          height: MediaQuery.of(context).size.height / 5,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("images/image2.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.play_arrow),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 18,
                            color: Colors.black54,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Easter Sunday Service",
                                  style: TextStyle(
                                      fontFamily: "RedHatDisplay",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                                Text(
                                  "Easter Sunday Service",
                                  style: TextStyle(
                                      fontFamily: "RedHatDisplay", fontSize: 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
