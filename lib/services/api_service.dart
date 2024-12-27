import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:facerecog/constants/api_constant.dart'; // Ganti dengan URL API Anda

class ApiService {
  static const String bearerToken = 'ZGV2ZWxvcGVyOnB3ZEBtaWswbQ=='; // Ganti dengan token yang sesuai
  static const String apiUrl = 'https://face.samarindakota.go.id'; // Ganti dengan URL API Anda

  // Fungsi login
  Future<bool> login(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Login berhasil
      } else {
        print('Login failed: ${response.body}');
        return false; // Login gagal
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  // Fungsi register
  Future<Map<String, dynamic>> register(String name, String email, String deviceId) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'device_id': deviceId,
        }),
      );

      // Debugging response
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Mengembalikan data dari respons dalam bentuk Map
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registering: $e');
    }
  }

  // Fungsi upload image
  Future<Map<String, dynamic>> uploadTrainImage(File image, String email) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/register_face'))
        ..files.add(await http.MultipartFile.fromPath('faces', image.path))
        ..fields['email'] = email  // Menambahkan email di sini
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $bearerToken',
        });

      var response = await request.send();  // Menggunakan send() pada request
      var responseBody = await response.stream.bytesToString();

      // Debugging response
      print('Upload Response Status Code: ${response.statusCode}');
      print('Upload Response Body: $responseBody');

      if (response.statusCode == 200) {
        return jsonDecode(responseBody); // Kembalikan response dalam bentuk Map
      } else {
        throw Exception('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
