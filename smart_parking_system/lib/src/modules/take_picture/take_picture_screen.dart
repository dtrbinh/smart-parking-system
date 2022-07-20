// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/route_provider.dart';
import 'package:smart_parking_system/src/data/provider/upload_firestorage_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;
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
      ResolutionPreset.high,
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
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Positioned(
            bottom: 20,
            child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: (() async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        if (!mounted) return;
                        Provider.of<FireStorageProvider>(context, listen: false)
                            .imagePath = image.path;
                        // print("Take a picture success: " +
                        //     Provider.of<FireStorageProvider>(context,
                        //             listen: false)
                        //         .imagePath
                        //         .toString());
                        Provider.of<RouteProvider>(context, listen: false)
                            .changeTakeSuccessfull();
                      } catch (e) {
                        // print(e);
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(1)),
                    child: const Icon(
                      Icons.circle,
                      size: 50,
                      color: Colors.blue,
                    )),
              ]),
            ))
      ],
    );
  }
}
