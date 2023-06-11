import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final picker = ImagePicker();
  File? _selectedImage;

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('No image selected.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8080/upload/');
    final fileName = path.basename(_selectedImage!.path);

    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
        filename: fileName,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Image uploaded successfully.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Image upload failed.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Uploader'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Icon(Icons.image),
          ),
          ElevatedButton(
            onPressed: _selectImage,
            child: const Text('Select Image'),
          ),
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
