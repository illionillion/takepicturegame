import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'take_picture_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key, required this.title, required this.camera});

  final String title;
  final CameraDescription camera;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late List<String> topics;
  String currentTopic = '';

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    // assets/ssd_mobilenet.txtからお題を読み込む処理
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/ssd_mobilenet.txt');
    setState(() {
      topics =
          data.split('\n').where((topic) => topic.isNotEmpty && !topic.contains('???')).toList();
      _getRandomTopic();
    });
  }

  void _getRandomTopic() {
    final random = Random();
    setState(() {
      currentTopic = topics[random.nextInt(topics.length)];
    });
  }

  void _navigateToCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TakePictureScreen(camera: widget.camera, topic: currentTopic),
      ),
    );

    if (result == true) {
      _getRandomTopic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'お題',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              currentTopic,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadTopics,
              child: const Text('お題を変える'),
            ),
            ElevatedButton(
              onPressed: _navigateToCamera,
              child: const Text('カメラを起動'),
            ),
          ],
        ),
      ),
    );
  }
}
