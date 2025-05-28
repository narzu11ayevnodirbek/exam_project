import 'package:exam_project/firebase_options.dart';
import 'package:exam_project/viewmodels/place_viewmodel.dart';
import 'package:exam_project/views/screens/auth/auth_screen.dart';
import 'package:exam_project/views/screens/home_screen.dart';
import 'package:exam_project/views/screens/onboardings/onboarding_screen.dart';
import 'package:exam_project/views/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _showOnboarding = !seenOnboarding;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return ChangeNotifierProvider(
      create: (_) => PlaceViewmodel()..loadPlaces(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            _isLoading
                ? const SplashScreen()
                : _showOnboarding
                ? const OnboardingScreen()
                : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    if (snapshot.hasData) {
                      return const HomeScreen();
                    }
                    return const AuthScreen();
                  },
                ),
      ),
    );
  }
}
