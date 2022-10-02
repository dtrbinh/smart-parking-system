import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/architecture/BaseViewModel.dart';
import 'package:smart_parking_system/data/provider/CameraProvider.dart';
import 'package:smart_parking_system/data/provider/GuardProvider.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';
import 'package:smart_parking_system/features/guard/scan_QR/ScanQRView.dart';
import 'package:smart_parking_system/features/guard/take_picture/TakePhotoView.dart';
import 'package:smart_parking_system/features/login_screen/LoginView.dart';

class GuardViewModel extends BaseViewModel {
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

  Widget getBody(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const TakePhotoView();
      case 1:
        return const ScanQRView();
      default:
        return const LoginView();
    }
  }

  void resetProvider() {
    selectedIndex = 0;
    takeSuccessful = false;
    confirmGenerate = false;
    notifyListeners();
  }

  void logout(BuildContext context) {
    try {
      context.read<GuardProvider>().deleteImageCache(
          File(context.read<GuardProvider>().guardRepository.imagePath));
      context.read<GuardViewModel>().resetProvider();
      context.read<CameraProvider>().resetProvider();
      context.read<GuardProvider>().resetProvider();
      context.read<GuardProvider>().accountRepository.handleSignOut();
    } catch (e) {
      logError('----------Internal Error: $e');
    } finally {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ));
    }
  }
}
