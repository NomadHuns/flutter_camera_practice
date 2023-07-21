import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "사진 저장하기",
                  style: TextStyle(fontSize: 50.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _takePhoto();
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  iconSize: 50.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto() async {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null && value.path != null) {
        print("저장경로 : ${value.path}");

        GallerySaver.saveImage(value.path).then((value) {
          print("사진이 저장되었습니다");
        });
      }
    });
  }
}

