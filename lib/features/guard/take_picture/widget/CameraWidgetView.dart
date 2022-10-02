import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';
import 'package:smart_parking_system/features/guard/GuardViewModel.dart';
import 'package:smart_parking_system/data/provider/GuardProvider.dart';

// A screen that allows users to take a picture using a given camera.
class CameraWidgetView extends StatefulWidget {
  const CameraWidgetView({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;
  @override
  CameraWidgetViewState createState() => CameraWidgetViewState();
}

class CameraWidgetViewState extends State<CameraWidgetView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
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
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(
                    child: SpinKitRipple(
                  color: Colors.white,
                  size: 100,
                  borderWidth: 10,
                ));
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
                        Provider.of<GuardProvider>(context, listen: false)
                            .guardRepository.imagePath = image.path;
                        logWarning(
                            "----------Take photo: ${Provider.of<GuardProvider>(context, listen: false).guardRepository.imagePath}");
                        Provider.of<GuardViewModel>(context, listen: false)
                            .changeTakeSuccessfull();
                      } catch (e) {
                        logError('----------Internal Error: $e');
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(1)),
                    child: const Icon(
                      Icons.circle,
                      size: 70,
                      color: Colors.black,
                    )),
              ]),
            ))
      ],
    );
  }
}
