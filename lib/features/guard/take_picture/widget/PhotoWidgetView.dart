import 'dart:io';
import 'package:flutter/material.dart';

class PhotoWidgetView extends StatelessWidget {
  final String imagePath;

  const PhotoWidgetView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
      fit: BoxFit.fill,
    );
  }
}
