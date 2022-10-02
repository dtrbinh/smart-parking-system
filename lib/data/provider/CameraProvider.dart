import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';

class CameraProvider extends ChangeNotifier {
  CameraDescription? firstCamera;
  CameraProvider() {
    initCamera();
  }
  void initCamera() async {
    try {
      final cameras = await availableCameras();
      firstCamera = cameras.first;
    } catch (e) {
      logError('----------Internal Error: $e');
    }
    notifyListeners();
  }

  void resetProvider() {
    firstCamera = null;
    notifyListeners();
  }
}
