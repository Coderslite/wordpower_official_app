import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wordpower_official_app/onboarding/onboarding_text.dart';
import 'package:wordpower_official_app/pages/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController(
    initialPage: 0,
  );
  List images = [
    'image2.jpg',
    'daddy1.jpg',
    // 'image5.jpg',
    'image8.jpg',
  ];
  List onboardingTexts = [
    'Welcome to Wordpower Minsitry',
    'A home of love and peace',
    // 'Find Commercial\nProperties',
    'Your blessings await you'
  ];

  int _currentPage = 0;
  Timer _timer;
  bool end = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage == 3) {
        end = true;
      } else if (_currentPage == 0) {
        end = false;
      }

      if (end == false) {
        _currentPage++;
      } else {
        _currentPage--;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: ((context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "images/" + images[index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(107, 107, 107, 0),
                          Color.fromRGBO(0, 0, 0, 0.9872),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(
                          flex: 2,
                        ),
                        OnboardingText(
                          text: onboardingTexts[index],
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Get started',
                      style: TextStyle(
                        color: Color(0xFFFEC121),
                        fontFamily: 'RedHatDisplay',
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 23,
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    spacing: 13,
                    expansionFactor: (19 / 8),
                    radius: 20,
                    activeDotColor: Colors.white,
                    dotColor: Color(0xFF656565),
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
                const SizedBox(
                  height: 2,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
