import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerProvider extends ChangeNotifier {
  Barcode? result;
  String qrResult = "";
  String imageURL = "";
  bool isScanning = true;
  
  void readResult(Barcode scanData) {
    result = scanData;
    qrResult = result!.code!;
    // print("Scan result: $qrResult");
    notifyListeners();
  }

  void scanSuccess() {
    isScanning = false;
    decodeQR();
    notifyListeners();
  }

  void decodeQR() {
    imageURL = qrResult.replaceAll("images/CAP", "images%2FCAP");
    // print("Image from QR: $imageURL");
  }

  void completeCheckOut() {
    deleteImage();
    resetProvider();
    notifyListeners();
  }

  void deleteImage() {
    FirebaseStorage.instance.refFromURL(imageURL).delete();
  }

  void resetProvider() {
    result = null;
    qrResult = "";
    imageURL = "";
    isScanning = true;
    notifyListeners();
  }
}
