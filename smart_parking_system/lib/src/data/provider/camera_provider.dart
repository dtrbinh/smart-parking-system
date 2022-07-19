import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraProvider extends ChangeNotifier {
  late CameraDescription firstCamera;
  CameraProvider() {
    initCamera();
    notifyListeners();
  }
  void initCamera() async {
    final cameras = await availableCameras();
    firstCamera = cameras.first;
    notifyListeners();
  }

  void resetProvider() {
    notifyListeners();
  }
}
