import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'scanned_text.dart';

class GetImage extends StatefulWidget {
  const GetImage({Key? key}) : super(key: key);

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to Text'),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () async {
            final XFile? imageFile =
                await ImagePicker().pickImage(source: ImageSource.camera);
            if (imageFile == null) return;
            setState(() {
              image = imageFile;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.camera_alt),
              SizedBox(width: 8),
              Text('Camera'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final XFile? imageFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (imageFile == null) return;
            setState(() {
              image = imageFile;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.photo_library),
              SizedBox(width: 8),
              Text('Gallery'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: image != null ? getTextFromImage : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.scanner_rounded),
              SizedBox(width: 8),
              Text('Scan Text'),
            ],
          ),
        ),
      ],
      body: image == null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  border: Border.all(color: Colors.black, width: 4),
                ),
              ),
            )
          : Image.file(
              File(image!.path),
              fit: BoxFit.contain,
            ),
    );
  }

  getTextFromImage() async {
    final inputImage = InputImage.fromFilePath(image!.path);
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
