import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_image_provider/device_image.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart' as lip;

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
  void initState() {
    super.initState();
  }

  Future<List<LocalImage>> getLocalImages() async {
    lip.LocalImageProvider imageProvider = lip.LocalImageProvider();
    bool hasPermission = await imageProvider.initialize();
    if (hasPermission) {
      // 최근 이미지 30개 가져오기
      List<LocalImage> images = await imageProvider.findLatest(30);
      if (images.isNotEmpty) {
        return images;
      } else {
        throw "이미지를 찾을 수 없습니다.";
      }
    } else {
      throw "이미지에 접근할 권한이 없습니다.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<LocalImage>>(
          future: getLocalImages(),
          builder: (context, snapshot) {
            return Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "사진 저장하기",
                      style: TextStyle(fontSize: 50.0),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: snapshot.hasData
                        ? snapshot.data!
                        .map((e) => Image(image: DeviceImage(e)))
                        .toList()
                        : [],
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
            );
          },
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