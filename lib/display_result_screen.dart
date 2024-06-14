import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

class DisplayResultScreen extends StatefulWidget {
  const DisplayResultScreen({super.key, required this.imagePath, required this.topic});

  final String imagePath;
  final String topic;

  @override
  _DisplayResultScreenState createState() => _DisplayResultScreenState();
}

class _DisplayResultScreenState extends State<DisplayResultScreen> {
  List _recognitions = [];
  bool _busy = false;
  bool _isTopicFound = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _detectObject(widget.imagePath);
  }

  _loadModel() async {
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );
  }

  _detectObject(String imagePath) async {
    setState(() {
      _busy = true; // TFLite処理中にフラグをセットして、インジケータを表示
    });

    var recognitions = await Tflite.detectObjectOnImage(
      path: imagePath,
      model: "SSDMobileNet",
      threshold: 0.5,
      numResultsPerClass: 1,
    );

    setState(() {
      _recognitions = recognitions!;
      _busy = false; // TFLite処理が完了したらフラグを解除して、インジケータを非表示にする
      _isTopicFound = _recognitions.any((re) => re["detectedClass"] == widget.topic);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('結果判定')),
      body: Center(
        child: _busy
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isTopicFound ? 'お題が見つかりました！' : 'お題が見つかりませんでした。',
                    style: TextStyle(fontSize: 24, color: _isTopicFound ? Colors.green : Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_isTopicFound);
                    },
                    child: Text(_isTopicFound ? '次のお題へ挑戦する' : 'もう一度挑戦する'),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
