import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:facerecog/services/api_service.dart';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart';
import 'AttendanceResponseScreen.dart';

class RecognizeFaceScreen extends StatefulWidget {
  final String email;
  final String location;  // Tambahkan parameter location

  const RecognizeFaceScreen({
    Key? key,
    required this.email,
    required this.location,  // Tambahkan location sebagai parameter
  }) : super(key: key);

  @override
  _RecognizeFaceScreenState createState() => _RecognizeFaceScreenState();
}

class _RecognizeFaceScreenState extends State<RecognizeFaceScreen> {
  File? file;
  String result = '';  // Define the result variable here
  bool isLoading = false;  // Add a variable to track loading state
  final ImagePicker _picker = ImagePicker();
  final ApiService apiService = ApiService();
  final String baseUrl = 'https://face.samarindakota.go.id/';  // Base URL

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          file = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<File> _compressImage(File imageFile) async {
    // Membaca file gambar sebagai byte
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());

    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    // Kompresi gambar dengan kualitas 85% dan pastikan ukuran kurang dari 1 MB
    int quality = 85;
    int maxSize = 1024 * 1024; // Maksimal 1 MB
    List<int> compressedBytes;

    do {
      compressedBytes = img.encodeJpg(image, quality: quality);
      if (compressedBytes.length > maxSize) {
        quality -= 5; // Kurangi kualitas jika ukuran lebih besar dari 1 MB
      }
    } while (compressedBytes.length > maxSize && quality > 10);

    // Simpan gambar terkompresi ke file baru
    return File('${imageFile.path}_compressed.jpg')..writeAsBytesSync(compressedBytes);
  }

  Future<Position> _getLocation() async {
    // Memeriksa apakah izin lokasi sudah diberikan
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Lokasi tidak diaktifkan
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    // Mendapatkan posisi lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> _uploadImage() async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image to upload.')),
      );
      return;
    }

    setState(() {
      isLoading = true;  // Set isLoading to true to show the loading indicator
    });

    try {
      // Mendapatkan lokasi GPS
      Position position = await _getLocation();
      String location = 'Lat: ${position.latitude}, Long: ${position.longitude}';

      // Kompresi gambar
      File compressedFile = await _compressImage(file!);

      var response = await apiService.recognizeFace(compressedFile, widget.email, location);

      if (response['status'] == 'success') {
        final message = response['message'];
        final status = response['data']['status'];
        final location = response['data']['location'];
        final faceImagePath = response['data']['face_image_path'];

        // Gabungkan path gambar dengan URL base
        final imageUrl = '$baseUrl$faceImagePath';

        // Navigasi ke halaman respon presensi dengan URL gambar lengkap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecognizeFaceScreen(
              email: widget.email,  // Kirim email seperti sebelumnya
              location: location,   // Kirim lokasi yang Anda dapatkan dari Geolocator
            ),
          ),
        );
      } else {
        setState(() {
          result = 'Failed to recognize face: ${response['message']}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error uploading image: $e';
      });
    } finally {
      setState(() {
        isLoading = false;  // Set isLoading to false after the request is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Recognition for Attendance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            file != null
                ? Image.file(file!, height: 200)
                : const Text('No image selected.'),
            const SizedBox(height: 20),
            Text(result), // Display result message here
            const SizedBox(height: 20),
            isLoading  // Show loading indicator if isLoading is true
                ? const CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
