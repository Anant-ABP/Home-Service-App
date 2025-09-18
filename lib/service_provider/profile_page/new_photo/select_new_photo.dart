import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectPhotoPage extends StatefulWidget {
  const SelectPhotoPage({super.key});

  @override
  State<SelectPhotoPage> createState() => _SelectPhotoPageState();
}

class _SelectPhotoPageState extends State<SelectPhotoPage> {
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      // Return the selected image to previous page
      Navigator.pop(context, _selectedImage);
    }
  }

  // Take photo using camera
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
      // Return the taken photo to previous page
      Navigator.pop(context, _selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Photo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.file(
                _selectedImage!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: Icon(Icons.camera_alt),
            label: Text('Take Photo'),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickFromGallery,
            icon: Icon(Icons.photo_library),
            label: Text('Pick from Gallery'),
          ),
        ],
      ),
    );
  }
}
