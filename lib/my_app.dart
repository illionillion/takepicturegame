import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'my_home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Picture Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomeScreen(title: 'Take Picture Game', camera: camera),
    );
  }
}
