import 'dart:io';
import 'package:flutter/material.dart';

class PhotoWidgetView extends StatelessWidget {
  final String imagePath;

  const PhotoWidgetView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.fitHeight,
    );
  }
}
