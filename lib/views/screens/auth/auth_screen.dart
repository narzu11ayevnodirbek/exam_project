import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredUsername = "";
  File? _selectedImage;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print(userCredentials);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print(userCredentials);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${userCredentials.user!.uid}.jpg");

        await storageRef.putFile(
          _selectedImage!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        print("Selected image path: ${_selectedImage!.path}");

        final imageUrl = await storageRef.getDownloadURL();
        print(imageUrl);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set({
              "username": _enteredUsername,
              "email": _enteredEmail,
              "image_url": imageUrl,
            });
        print("User data saved to Firestore");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        //
      }
      print("Firebase Exception: ${e.code} - ${e.message}");
      print("StackTrace: ${e.stackTrace}");

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentification failed")),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Text(
                  _isLogin ? "Sign in now" : "Sign up now",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFF1B1E28),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _isLogin
                      ? "Please sign in to continue our app"
                      : "Please fill the details and create account",
                  style: TextStyle(fontSize: 16, color: Color(0xFF7D848D)),
                ),
                if (!_isLogin)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: const Color(0xFFF7F7F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Color(0xFF0D6EFD),
                          width: 2,
                        ),
                      ),
                    ),
                    enableSuggestions: false,

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length < 4) {
                        return 'Please enter at least 4 characters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredUsername = value!;
                    },
                  ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    filled: true,
                    fillColor: Color(0xFFF7F7F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Color(0xFF0D6EFD),
                        width: 2,
                      ),
                    ),
                  ),
                  autocorrect: false,

                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains("@")) {
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredEmail = newValue!;
                  },
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Color(0xFFF7F7F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Color(0xFF0D6EFD),
                        width: 2,
                      ),
                    ),
                  ),
                  obscureText: true,

                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),

                if (_isAuthenticating) CircularProgressIndicator(),
                if (!_isAuthenticating)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFF0D6EFD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _submit,
                      child: Text(
                        _isLogin ? "Login" : "Sign Up",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (!_isAuthenticating)
                  TextButton(
                    onPressed: () {
                      _isLogin = !_isLogin;
                      setState(() {});
                    },
                    child: Text(
                      _isLogin
                          ? "Create an Account"
                          : "I already have an account. Login.",
                      style: TextStyle(color: Color(0xFF0D6EFD)),
                    ),
                  ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF1877F2),
                      ),
                      child: SvgPicture.asset("assets/icons/facebook.svg"),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFD521),
                            Color(0xFFFFD521),
                            Color(0xFFF50000),
                            Color(0xFFB900B4),
                            Color(0xFFB900B4),
                            Color(0xFFB900B4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                        ),
                      ),
                      child: Image.asset(
                        "assets/images/instagram.png",
                        width: 5,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF03A9F4),
                      ),
                      child: SvgPicture.asset("assets/icons/twitter.svg"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
