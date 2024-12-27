import 'package:flutter/material.dart';

class AttendanceResponseScreen extends StatelessWidget {
  final String status;
  final String message;
  final String location;
  final String imagePath;

  const AttendanceResponseScreen({
    Key? key,
    required this.status,
    required this.message,
    required this.location,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Response')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status: $status'),
            Text('Message: $message'),
            Text('Location: $location'),
            Image.network(imagePath),
          ],
        ),
      ),
    );
  }
}
