// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'service.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  Service service = Service();
  final _addFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Images'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Card(
              child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text('Image Title'),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              OutlinedButton(onPressed: getImage, child: _buildImage()),
              Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_addFormKey.currentState!.validate()) {
                        _addFormKey.currentState!.save();
                        Map<String, String> body = {
                          'title': _titleController.text
                        };
                        service.addImage(body, _image.path);
                      }
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (_image == null) {
      return const Padding(
        padding: EdgeInsets.zero,
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Text(_image.path);
    }
  }
}
