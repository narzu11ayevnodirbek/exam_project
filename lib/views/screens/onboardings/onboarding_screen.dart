import 'package:exam_project/views/screens/auth/auth_screen.dart';
import 'package:exam_project/views/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Widget _buildImage(String assetName, [double width = double.infinity]) {
    return Image.asset(
      'assets/images/$assetName',
      width: width,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: false,
      autoScrollDuration: 3000,
      infiniteAutoScroll: false,

      globalFooter: Padding(
        padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Color(0xFF0D6EFD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "It's a big world out there go explore",
          body:
              "To get the best of your adventure you just need to leave and go where you like. we are waiting for you",
          image: _buildImage('on1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "It's a big world out there go explore",
          body:
              "To get the best of your adventure you just need to leave and go where you like. we are waiting for you",
          image: _buildImage('on2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "People don't take trips, trips take people",
          body:
              "To get the best of your adventure you just need to leave and go where you like. we are waiting for you",
          image: _buildImage('on3.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward, color: Color(0xFF0D6EFD)),
      done: const Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0D6EFD)),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding:
          kIsWeb
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(7.0, 7.0),
        color: Color(0xFFCAEAFF),
        activeSize: Size(35.0, 7.0),
        activeColor: Color(0xFF0D6EFD),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
