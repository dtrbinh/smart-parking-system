import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class FireStorageProvider extends ChangeNotifier {
  String imagePath = "";
  String linkImageFireStorage = "";
  String linkQR = "";
  List<String> qrHistory = [];

  Future<void> uploadtoFireStorage() async {
    final firebaseStorage = FirebaseStorage.instance;
    var file = File(imagePath);
    final String fileName = basename(imagePath);
    //Up xong check upload Success rồi xoá local, get lại link ảnh để generate qr
    if (imagePath != "" && fileName != "") {
      var snapshot = await firebaseStorage
          .ref()
          .child('Car_images/$fileName')
          .putFile(file);
      linkImageFireStorage = await snapshot.ref.getDownloadURL();
      generateQR();
    } else {
      // print('No Image Path Received');
    }
    deleteFile(File(imagePath));
    notifyListeners();
  }

  void generateQR() {
    // print(linkImageFireStorage);
    linkQR =
        "http://api.qrserver.com/v1/create-qr-code/?data=$linkImageFireStorage&size=400x400";
    // print("QR: $linkQR");
    qrHistory.add(linkQR);
    notifyListeners();
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  void resetProvider() {
    imagePath = "";
    linkImageFireStorage = "";
    linkQR = "";
    qrHistory = [];
    notifyListeners();
  }
}
