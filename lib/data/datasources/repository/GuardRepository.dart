import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smart_parking_system/data/models/DetectBox.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';

import '../../models/Parker.dart';

class GuardRepository {
  static final GuardRepository _instance = GuardRepository();

  static GuardRepository get instance {
    return _instance;
  }

  final imageStorage = FirebaseStorage.instance;
  final dataStorage = FirebaseFirestore.instance;

  String imagePath = "";
  String linkImageFireStorage = "";
  String linkQR = '';
  List<String> qrHistory = [];
  bool isDetect = false;
  bool isDetectSuccess = false;
  bool isOcrSuccess = false;
  DetectBox? detectBox;
  List<File> listNumplate = [];
  List<String> listNumplateText = [];

  Future<void> postImage() async {
    var file = File(imagePath);
    final String fileName = basename(imagePath);
    //upload to cloud storage-> get link image -> generate qr -> detect numplate -> delete local image
    if (imagePath != "" && fileName != "") {
      try {
        await imageStorage
            .ref()
            .child('car_images/$fileName')
            .putFile(file)
            .then((p0) async {
          linkImageFireStorage = await p0.ref.getDownloadURL();
        }).onError((error, stackTrace) async {
          logError('----------Internal Error: $error');
          await Sentry.captureException(
            error,
            stackTrace: stackTrace,
          );
        });
      } catch (e, stackTrace) {
        logError('----------Internal Error: $e');
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      } finally {

      }
    } else {
      logError('----------Internal Error: No image to upload.');
      await Sentry.captureException(
        Exception("No image to upload."),
        stackTrace: null,
      );
    }
    // notifyListeners();
  }

  Future<void> postData() async {
    dataStorage.settings = const Settings(persistenceEnabled: true);
    CollectionReference parkers = dataStorage.collection('Parkers');
    String fileName = basename(imagePath);
    fileName = fileName.replaceAll('CAP', '');
    fileName = fileName.replaceAll('.jpg', '');
    Parker newParker =
        Parker(fileName, listNumplateText[0], linkImageFireStorage, linkQR);
    parkers.doc(newParker.parkerID).set(newParker.toJson()).then((value) {
      // print('Parker add success');
    }).catchError((error, stackTrace) async {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    });
  }

  Future<void> deleteImage(String imageURL) async {
    FirebaseStorage.instance.refFromURL(imageURL).delete().then((value) {
      logWarning(
          '----------Deleted image: $imageURL.');
    }).catchError((error, stackTrace) async {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        Exception(error),
        stackTrace: stackTrace,
      );
    });
  }
}
