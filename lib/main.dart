import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';


main() {
  runApp(CameraApp());
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  Future<CameraController> useCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> cameras = await availableCameras();
    CameraController controller =
    CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<CameraController>(
          future: useCamera(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print("나실행중");
              return CircularProgressIndicator();
            } else {
              print("나 이제 실행됨");
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "카메라 프리뷰",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(child: CameraPreview(snapshot.data!)),
                    Text(
                      "저장된 사진 불러오기",
                      style: TextStyle(fontSize: 30),
                    ),
                    FutureBuilder<File>(
                      future: getFileImage(),
                      builder: (context, snapshot) {
                        return Expanded(
                            child: Image.file(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ));
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final directory =
                          await getApplicationDocumentsDirectory();

                          XFile xFile = await snapshot.data!.takePicture();
                          xFile.saveTo("${directory.path}/1.jpg");
                          print("사진 찍힘 ${directory.path}/1.jpg");
                        },
                        child: Text("촬영")),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // CAP1089117287322915032.jpg
  Future<File> getFileImage() async {
    final _fileName = "1.jpg";
    final directory = await getApplicationDocumentsDirectory();
    String _path = directory.path;
    print("파일 경로 : $_path");
    try {
      final file = File('$_path/$_fileName');
      return file;
    } catch (e) {
      throw "파일 읽기 실패";
    }
  }
}


