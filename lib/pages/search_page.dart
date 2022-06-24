import 'package:flutter/material.dart';
import 'package:wordpower_official_app/constant/search_json.dart';
import 'package:wordpower_official_app/pages/widget/search_category_item.dart';
import 'package:wordpower_official_app/theme/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: size.width - 30,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: textFieldBackground,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: white.withOpacity(0.3),
                      ),
                    ),
                    style: TextStyle(
                      color: white.withOpacity(0.3),
                    ),
                    cursorColor: white.withOpacity(0.3),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                  children: List.generate(searchCategories.length, (index) {
                return CategoryStoryItem(name: searchCategories[index]);
              })),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Wrap(
            spacing: 1,
            runSpacing: 1,
              children: List.generate(searchImage.length, (index) {
            return Container(
              height: (size.width-3)/3,
              width: (size.width-3)/3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(searchImage[index]), fit: BoxFit.cover),
              ),
            );
          }))
        ],
      ),
    );
  }
}
