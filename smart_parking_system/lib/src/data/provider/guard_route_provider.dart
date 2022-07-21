import 'package:flutter/cupertino.dart';
import 'package:smart_parking_system/src/modules/guard/scan_QR/scan_QR.dart';
import 'package:smart_parking_system/src/modules/guard/take_picture/take_picture.dart';
import 'package:smart_parking_system/src/modules/login_screen/login_screen.dart';

class GuardRouteProvider extends ChangeNotifier {
  int selectedIndex = 0;
  bool takeSuccessful = false;
  bool confirmGenerate = false;

  void changeConfirmGenerate() {
    confirmGenerate = !confirmGenerate;
    notifyListeners();
  }

  void changeTakeSuccessfull() {
    takeSuccessful = !takeSuccessful;
    notifyListeners();
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return const TakePicture();
      case 1:
        return const ScanQRCode();
      default:
        return const LoginScreen();
    }
  }

  void resetProvider() {
    selectedIndex = 0;
    takeSuccessful = false;
    confirmGenerate = false;
    notifyListeners();
  }
}
