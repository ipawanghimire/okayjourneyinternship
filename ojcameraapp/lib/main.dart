import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<File> _imageList = [];

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? picture = await _picker.pickImage(source: ImageSource.camera);

    if (picture != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/${DateTime.now()}.png';

      final File newImage = await File(picture.path).copy(imagePath);
      setState(() {
        _imageList.add(newImage);
      });

      _showSnackBar('Picture saved to gallery');
      GallerySaver.saveImage(imagePath);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Camera App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.file(_imageList[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
          ),
        ],
      ),
    );
  }
}
