import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostImageList extends StatefulWidget {
  final String postId;
  final List imageList;

  const PostImageList({Key key,this.postId,this.imageList})
      : super(key: key);

  @override
  _PostImageListState createState() => _PostImageListState();
}

class _PostImageListState extends State<PostImageList> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // List<String> imgList =  widget.imageList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                autoPlay: false,
                aspectRatio: 2.0,
                viewportFraction: 1,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: widget.imageList
                  .map(
                    (item) => Center(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              InteractiveViewer(
                                child: Image.network(item,
                                    fit: BoxFit.cover, width: 1000.0),
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  // child: Text(
                                  //   'No. ${imgList.indexOf(item)} image',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 20.0,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            CarouselIndicator(
                imgList: widget.imageList,
                controller: _controller,
                current: _current),
          ],
        ),
      ),
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator({
    Key key,
    this.imgList,
    CarouselController controller,
    int current,
  })  : _controller = controller,
        _current = current,
        super(key: key);

  final List imgList;
  final CarouselController _controller;
  final int _current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imgList.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.animateToPage(entry.key),
          child: Container(
            width: 12.0,
            height: 12.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white)
                    .withOpacity(_current == entry.key ? 0.9 : 0.4)),
          ),
        );
      }).toList(),
    );
  }
}
