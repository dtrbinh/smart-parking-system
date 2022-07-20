import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_parking_system/src/data/models/parker.dart';

class ScannerProvider extends ChangeNotifier {
  Barcode? result;
  String qrResult = "";
  String imageURL = "";
  bool isScanning = true;

  bool isFetching = true;
  bool isCheckOut = true;
  Timestamp checkOutTime = Timestamp(0, 0);

  void readResult(Barcode scanData) {
    result = scanData;
    qrResult = result!.code!;
    // print("Scan result: $qrResult");
    notifyListeners();
  }

  void scanSuccess() {
    isScanning = false;
    decodeQR();
    checkParker();
    notifyListeners();
  }

  void decodeQR() {
    imageURL = qrResult.replaceAll("images/CAP", "images%2FCAP");
    //print("Image from QR: $imageURL");
  }

  Future<void> checkParker() async {
    print('------------------Checking-----------------');
    final fireStore = FirebaseFirestore.instance;
    String parkerID = imageURL.substring(
        imageURL.indexOf('CAP') + 3, imageURL.indexOf('.jpg'));
    print(parkerID);
    final doc = await fireStore.collection("Parkers").doc(parkerID).get();
    Parker parkerCheckOut = Parker.fromJson(doc.data() as Map<String, dynamic>);
    isCheckOut = parkerCheckOut.isCheckOut;
    checkOutTime = parkerCheckOut.checkOut;
    isFetching = false;
    notifyListeners();
  }

  void updateParker() {
    final fireStore = FirebaseFirestore.instance;
    String parkerID = imageURL.substring(
        imageURL.indexOf('CAP') + 3, imageURL.indexOf('.jpg'));
    CollectionReference parkers = fireStore.collection("Parkers");
    parkers.doc(parkerID).update(
        {'checkOut': Timestamp.now(), 'isCheckOut': true}).then((value) {
      print('Parker updated. Checkout success');
    }).catchError((error) => {print('Parker update fail: $error')});
    notifyListeners();
  }

  Future<void> completeCheckOut() async {
    updateParker();
    resetProvider();
    notifyListeners();
  }

  Future<void> deleteImage() async {
    FirebaseStorage.instance
        .refFromURL(imageURL)
        .delete()
        .then((value) => print('Delete success.'))
        .catchError((error) => {print('Delete error: $error')});
  }

  void resetProvider() {
    result = null;
    qrResult = "";
    imageURL = "";
    isScanning = true;
    isCheckOut = true;
    isFetching = true;
    checkOutTime = Timestamp(0, 0);
    notifyListeners();
  }
}
