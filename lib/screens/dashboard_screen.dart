import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'upload_image_screen.dart';
import 'face_recognition_screens.dart'; // Import the Face Recognition screen

class DashboardScreen extends StatelessWidget {
  final String email; // Menyimpan email yang diteruskan

  // Konstruktor menerima email
  const DashboardScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, $email!',  // Menampilkan email yang diteruskan
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Face Recognition Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecognizeFaceScreen(
                      email: email, // Pass the email to RecognizeFaceScreen
                      location: location, // Pass location or get dynamically
                    ),
                  ),
                );
              },
              child: const Text('Start Face Recognition'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Placeholder for future features
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature not implemented yet!')),
                );
              },
              child: const Text('View Results'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Placeholder for settings or other actions
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature not implemented yet!')),
                );
              },
              child: const Text('Settings'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Upload Image Screen for training images
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UploadImageScreen(email: email)), // Kirim email ke UploadImageScreen
                );
              },
              child: const Text('Upload Training Images'),
            ),
          ],
        ),
      ),
    );
  }
}
