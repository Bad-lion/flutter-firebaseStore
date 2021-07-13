import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  MyImagePicker(this.imagePickFn);
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 300,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
        ),
        child: _pickedImage != null
            ? Image.file(
                _pickedImage!,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.photo_camera,
                size: 100,
              ),
      ),
    );
  }
}
