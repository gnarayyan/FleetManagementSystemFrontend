import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './services.dart';
import 'dart:io';
import 'package:path/path.dart';

class DjangoImage extends StatefulWidget {
  const DjangoImage({super.key});

  @override
  State<DjangoImage> createState() => _DjangoImageState();
}

class _DjangoImageState extends State<DjangoImage> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload Example'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: FutureBuilder(
                  future: _getImage(context),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Text('Please wait');
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return selectedImage != null
                              ? Image.file(selectedImage!)
                              : const Center(
                                  child: Text('Please Get the Image'),
                                );
                        }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
            ),
            onPressed: () {
              submitForm(
                  file: selectedImage, filename: basename(selectedImage!.path));
            },
            child: const Text("Upload"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  //get image from camera
  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image!.path);
    });
    //return image;
  }

  //resize the image
  Future<void> _getImage(BuildContext context) async {
    if (selectedImage != null) {
      var imageFile = selectedImage;
      /*var image = imageLib.decodeImage(imageFile.readAsBytesSync());
      fileName = basename(imageFile.path);
      image = imageLib.copyResize(image,
          width: (MediaQuery.of(context).size.width * 0.8).toInt(),
          height: (MediaQuery.of(context).size.height * 0.7).toInt());
      _image = image;*/
    }
  }
}
