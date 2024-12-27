import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ApiService apiService = ApiService();
  String? password;  // Variabel untuk menyimpan password dari respons API

  Future<void> _register() async {
    try {
      String deviceId = 'unique_device_id'; // Ganti dengan device_id yang sesuai

      // Mengambil respons dari API yang mengembalikan Map
      Map<String, dynamic> response = await apiService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        deviceId,
      );

      // Debug: Cetak respons untuk memeriksa apakah password ada di dalam respons
      print('API Response: $response');

      // Jika ada password yang dikembalikan, simpan untuk ditampilkan
      if (response.containsKey('password')) {
        setState(() {
          password = response['password'];  // Simpan password dari respons
        });
      } else {
        setState(() {
          password = 'No password provided in response';
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration successful. You can now log in.'),
      ));

      Navigator.pop(context);  // Kembali ke halaman login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Already have an account? Log in here.'),
            ),
            const SizedBox(height: 20),
            if (password != null) ...[
              Text('Password (from API): $password'),  // Menampilkan password dari respons
            ],
          ],
        ),
      ),
    );
  }
}
