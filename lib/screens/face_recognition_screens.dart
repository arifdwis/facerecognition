// class FaceRecognitionScreen extends StatefulWidget {
//   const FaceRecognitionScreen({Key? key}) : super(key: key);

//   @override
//   _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
// }

// class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
//   File? file;
//   String result = '';
//   final ImagePicker _picker = ImagePicker();
//   final String apiUrl =
//       "http://192.168.23.23:5000/upload_image"; // Replace with your API URL

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           file = File(pickedFile.path);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No image selected.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (file == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No image to upload.')),
//       );
//       return;
//     }

//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       request.files.add(await http.MultipartFile.fromPath('file', file!.path));
//       request.headers.addAll({
//         'Accept': 'application/json',
//         'Content-Type': 'multipart/form-data',
//       });

//       var response = await request.send();
//       var responseBody = await http.Response.fromStream(response);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(responseBody.body) as List;
//         final name = data[0]['name'];
//         final distance = data[0]['distance'];
//         setState(() {
//           result =
//               'Name: $name, Confidence: ${(1 - distance) * 100}%'; // Update the result
//         });
//       } else {
//         setState(() {
//           result = 'Error: ${response.statusCode}, ${responseBody.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         result = 'Error uploading image: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Face Recognition')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             file != null
//                 ? Image.file(file!, height: 200)
//                 : const Text('No image selected.'),
//             const SizedBox(height: 20),
//             Text(result), // Display the result here
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => _pickImage(ImageSource.camera),
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Camera'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                   icon: const Icon(Icons.image),
//                   label: const Text('Gallery'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploadImage,
//               child: const Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
