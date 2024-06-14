import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'display_result_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera, required this.topic});

  final CameraDescription camera;
  final String topic;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('写真を撮影')),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // コントローラが初期化されていることを確認
            await _initializeControllerFuture;

            // 写真を撮影
            final image = await _controller.takePicture();

            // DisplayResultScreenに画像パスとお題を渡して遷移
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayResultScreen(
                  imagePath: image.path,
                  topic: widget.topic,
                ),
                fullscreenDialog: true,
              ),
            );

            Navigator.of(context).pop(result == true);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
