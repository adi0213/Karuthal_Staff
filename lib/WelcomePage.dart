import 'dart:ui';

import 'package:chilla_staff/Login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<String> images = [
    'assets/old2.webp',
    'assets/karuthal3.jpg',
    'assets/Old1.webp',
    'assets/old3.jpg',
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: Duration(seconds: 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Image.asset(
                        images[_currentIndex],
                        key: ValueKey(_currentIndex),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                      ),
                    ),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    height: 10,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 10),
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.04 * MediaQuery.of(context).size.height),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    child: Image.asset('assets/chilla_image.png'),
                  ),
                  SizedBox(height: 0.04 * MediaQuery.of(context).size.height),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(190, 52),
                      backgroundColor: Color(0xFF38A3A5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.black,
                      elevation: 9,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1 * MediaQuery.of(context).size.height),
          ],
        ),
      ),
    );
  }
}
