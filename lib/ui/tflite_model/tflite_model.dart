import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({super.key});

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  List<dynamic> _recognitions = [];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> runTextRecognitionOnImage(String imagePath) async {
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 2,
      threshold: 0.5,
    );

    setState(() {
      _recognitions = recognitions ?? [];
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Recognition'),
      ),
      body: Column(
        children: [
          // Add your image widget here

          ElevatedButton(
            onPressed: () {
              // Call your image picker here to select an image
              // and pass the selected image path to the method below
              runTextRecognitionOnImage('breakfast_images/egg pratha.jpg');
            },
            child: const Text('Recognize Text'),
          ),

          // Display the recognized text
          const Text('Recognized Text:'),
          for (var recognition in _recognitions) Text(recognition['label']),
        ],
      ),
    );
  }
}
