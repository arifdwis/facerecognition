import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:facerecog/services/api_service.dart';
import 'package:facerecog/screens/dashboard_screen.dart';
import 'dashboard_screen.dart';

class UploadImageScreen extends StatefulWidget {
  final String email; // Menerima email sebagai parameter

  const UploadImageScreen({Key? key, required this.email}) : super(key: key); // Menambahkan parameter email

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ApiService apiService = ApiService();
  final List<File> _images = [];
  bool isUploading = false;

  // Fungsi untuk memilih gambar dari galeri atau kamera
  Future<void> _pickImages() async {
    if (_images.length < 10) {
      final ImagePicker _picker = ImagePicker();

      // Menampilkan dialog untuk memilih sumber gambar (kamera atau galeri)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick an Image Source'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _images.add(File(pickedFile.path));
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Camera'),
              ),
              TextButton(
                onPressed: () async {
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _images.add(File(pickedFile.path));
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Gallery'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can upload a maximum of 10 photos.')),
      );
    }
  }

  // Fungsi untuk meng-upload gambar
  Future<void> _uploadImages() async {
    setState(() {
      isUploading = true;
    });

    if (widget.email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      setState(() {
        isUploading = false;
      });
      return;
    }

    try {
      for (File image in _images) {
        var response = await apiService.uploadTrainImage(image, widget.email);  // Menggunakan widget.email
        print('Upload response: $response');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(email: widget.email), // Pastikan email diteruskan
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Images for Training')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Email:'),
            Text(widget.email),  // Menampilkan email yang diteruskan
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUploading ? null : _pickImages,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            if (_images.isNotEmpty) ...[
              const Text('Selected Images:'),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(_images[index]),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _images.isEmpty || isUploading ? null : _uploadImages,
              child: isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload Images'),
            ),
          ],
        ),
      ),
    );
  }
}
