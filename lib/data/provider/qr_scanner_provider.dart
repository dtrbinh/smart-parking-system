import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_parking_system/data/models/parker.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';

class ScannerProvider extends ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
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
  }

  Future<void> checkParker() async {
    String parkerID = imageURL.substring(
        imageURL.indexOf('CAP') + 3, imageURL.indexOf('.jpg'));
    await fireStore.collection("Parkers").doc(parkerID).get().then((value) {
      try {
        Parker parkerCheckOut =
            Parker.fromJson(value.data() as Map<String, dynamic>);
        isCheckOut = parkerCheckOut.isCheckOut;
        checkOutTime = parkerCheckOut.checkOut;
        isFetching = false;
      } catch (e) {
        logError('----------Internal Error: $e');
      } finally {
        notifyListeners();
      }
    }).onError((error, stackTrace) {
      logError('----------Internal Error: $error');
    });
  }

  void updateParkerCheckout() {
    String parkerID = imageURL.substring(
        imageURL.indexOf('CAP') + 3, imageURL.indexOf('.jpg'));
    CollectionReference parkers = fireStore.collection("Parkers");
    parkers.doc(parkerID).update(
        {'checkOut': Timestamp.now(), 'isCheckOut': true}).then((value) {
      logWarning('----------Update parker checkout success.');
    }).catchError((error) {
      logError('----------Internal Error: $error');
    });
    notifyListeners();
  }

  Future<void> completeCheckout() async {
    updateParkerCheckout();
    resetProvider();
    notifyListeners();
  }

  Future<void> deleteImage() async {
    FirebaseStorage.instance.refFromURL(imageURL).delete().then((value) {
      logWarning('----------Delete image success.');
    }).catchError((error) {
      logError('----------Internal Error: $error');
    });
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