
import 'package:flutter/material.dart';

class ScannedText extends StatelessWidget {
  final String text;
  const ScannedText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.repeat),
      ),
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
