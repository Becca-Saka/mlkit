import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends StatelessWidget {
  const GetImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Pick an image'),
              onPressed: () {
                ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((file) {
                  if (file == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanImage(image: file),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScanImage extends StatelessWidget {
  final XFile image;
  const ScanImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.scanner),
        onPressed: () => getTextFromImage(context),
      ),
      body: SafeArea(
        child: Image.file(
          File(image.path),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  getTextFromImage(context) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDectector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText =
        await textDectector.processImage(inputImage);
    await textDectector.close();
    String text = recognizedText.text;

    for (TextBlock block in recognizedText.blocks) {
      text = text + block.text + '\n';

      // for (TextLine line in block.lines) {
      //   text = text + line.text + '\n';
      // }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScannedText(text: text),
      ),
    );
  }
}

class ScannedText extends StatelessWidget {
  final String text;
  const ScannedText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SelectableText(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
