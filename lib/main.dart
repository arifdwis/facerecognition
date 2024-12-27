import 'package:flutter/material.dart';
import 'package:facerecog/screens/login_screen.dart';
import 'package:facerecog/services/http_override.dart';  // Import the HttpOverrides file
import 'dart:io';  // Import dart:io for HttpOverrides

void main() {
  HttpOverrides.global = MyHttpOverrides();  // Set the custom HttpOverrides globally
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
