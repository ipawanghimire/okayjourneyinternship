import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Favourite Actor',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(title: 'Actor Gallery'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<ImageData> _imageList = [];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      final imageName = _nameController.text;

      setState(() {
        _imageList.add(ImageData(
          name: imageName,
          imageBytes: imageBytes,
        ));
      });

      Navigator.pop(context); // Close the dialog after image selection
    }
  }

  void _addImage() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Gallery'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Please write the name of your Favourite actor and select an image",style: TextStyle(
            fontWeight: FontWeight.bold,color: Colors.purpleAccent,
          ),textAlign: TextAlign.center),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addImage,
                  child: Text('Add Image'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GalleryPage(images: _imageList)),
          );
        },
        tooltip: 'Show Images',
        child: Icon(Icons.photo_album),
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  final List<ImageData> images;

  GalleryPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Image Gallery'),
    ),
    body: GridView.count(
    crossAxisCount: 2,
    children: List.generate(
    images.length,
    (index) {
      final imageData = images[index];
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(imageData: imageData)),
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.memory(
                  Uint8List.fromList(imageData.imageBytes),
                ),
                SizedBox(height: 5),
                Text(
                  imageData.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
      );
    }
    ),
    ),
    );
  }
}

class ImageData {
  final String name;
  final List<int> imageBytes;

  ImageData({
    required this.name,
    required this.imageBytes,
  });
}

class DetailPage extends StatelessWidget {
  final ImageData imageData;

  DetailPage({required this.imageData});

  @override
  Widget build(BuildContext context) {
    final bytes = Uint8List.fromList(imageData.imageBytes);
    return Scaffold(
      appBar: AppBar(
        title: Text(imageData.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              bytes,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              imageData.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
