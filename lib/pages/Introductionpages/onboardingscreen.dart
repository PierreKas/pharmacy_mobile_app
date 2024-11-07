import 'package:flutter/material.dart';
import 'package:pharmacy/pages/Introductionpages/intropage1.dart';
import 'package:pharmacy/pages/Introductionpages/intropage2.dart';
import 'package:pharmacy/pages/login_page.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
////
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_controller.page != null && _controller.page!.toInt() < 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } else {
        _timer?.cancel(); // Stop the timer if on the last page
      }
      // if (_controller.page != null) {
      //   int nextPage = (_controller.page!.toInt() + 1) % 2;
      //   _controller.animateToPage(
      //     nextPage,
      //     duration: const Duration(milliseconds: 500),
      //     curve: Curves.easeIn,
      //   );
      // }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 1);
            });
            _resetTimer();
          },
          children: const [
            IntroPage1(),
            IntroPage2(),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(1);
                    _resetTimer();
                  },
                  child: const Text(
                    'sauter',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect: CustomizableEffect(
                  //decoration for active page
                  activeDotDecoration: DotDecoration(
                    width: 30,
                    height: 8,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  //decoration for inactive page(s)
                  dotDecoration: DotDecoration(
                    width: 30,
                    height: 8,
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  spacing: 8.0,
                ),
              ),
              onLastPage
                  ? GestureDetector(
                      onTap: () {
                        _resetTimer();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                      child: const Text(
                        'Commencer',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.ease);
                        _resetTimer();
                      },
                      child: const Text(
                        'suivant',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
            ],
          ),
        )
      ]),
    );
  }
}
