import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:smart_parking_system/data/models/detect_box.dart';
import 'package:smart_parking_system/data/models/parker.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';

class StorageProvider extends ChangeNotifier {
  final imageStorage = FirebaseStorage.instance;
  final dataStorage = FirebaseFirestore.instance;

  String imagePath = "";
  String linkImageFireStorage = "";

  String linkQR = "";
  List<String> qrHistory = [];

  bool isDetect = false;
  bool isDetectSuccess = false;
  bool isOcrSuccess = false;
  DetectBox? detectBox;
  List<File> listNumplate = [];
  List<String> listNumplateText = [];

  Future<void> uploadImage() async {
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
          generateQR();
          getNumplate();
        }).onError((error, stackTrace) {
          logError('----------Internal Error: $error');
        });
        await uploadData();
      } catch (e) {
        logError('----------Internal Error: $e');
      } finally {
        notifyListeners();
      }
    } else {
      logError('----------Internal Error: No image to upload.');
    }

    notifyListeners();
  }

  Future<void> uploadData() async {
    dataStorage.settings = const Settings(persistenceEnabled: true);
    CollectionReference parkers = dataStorage.collection('Parkers');
    String fileName = basename(imagePath);
    fileName = fileName.replaceAll('CAP', '');
    fileName = fileName.replaceAll('.jpg', '');
    Parker newParker = Parker(fileName, linkImageFireStorage, linkQR);
    parkers.doc(newParker.parkerID).set(newParker.toJson()).then((value) {
      // print('Parker add success');
    }).catchError((error) {
      logError('----------Internal Error: $error');
    });
  }

  void generateQR() {
    linkQR =
        "http://api.qrserver.com/v1/create-qr-code/?data=$linkImageFireStorage&size=400x400";
    qrHistory.add(linkQR);
    notifyListeners();
  }

  void getNumplate() async {
    await http
        .get(Uri.parse(dotenv.env['ROBOFLOW_MODEL_URL_V4']!)
            .replace(queryParameters: {
      'api_key': dotenv.env['ROBOFLOW_API_KEY'],
      'image': linkImageFireStorage,
      'confidence': '0.7',
    }))
        .then((response) async {
      logWarning(response.body);
      detectBox = DetectBox.fromJson(json.decode(response.body));
      await cropNumplateFrame();
      await ocrScan();
    }, onError: (error) {
      logError('----------Internal Error: $error');
    });
  }

  Future<void> cropNumplateFrame() async {
    try {
      for (int i = 0; i < detectBox!.predictions.length; i++) {
        var numplate = await FlutterNativeImage.cropImage(
          imagePath,
          detectBox!.predictions[i].x.toInt() -
              detectBox!.predictions[i].width ~/ 2,
          detectBox!.predictions[i].y.toInt() -
              detectBox!.predictions[i].height ~/ 2,
          detectBox!.predictions[i].width,
          detectBox!.predictions[i].height,
        );
        listNumplate.add(numplate);
        logWarning(
            '------------Model detected ${i + 1} numplate: ${listNumplate[i].path}');
      }
      if (listNumplate.isNotEmpty) {
        isDetectSuccess = true;
      } else {
        isDetectSuccess = false;
      }
    } catch (e) {
      isDetectSuccess = false;
      logError('----------Internal Error: $e');
    } finally {
      isDetect = true;
      deleteImageCache(File(imagePath));
      notifyListeners();
    }
  }

  Future<void> ocrScan() async {
    try {
      if (isDetectSuccess) {
        //scan image
      } else {
        logError('----------Internal Error: No image to scan.');
      }
    } catch (e) {
      logError('----------Internal Error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteImageCache(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        logWarning('------------Deleted picture: ${file.path}');
      } else {}
    } catch (e) {
      logError('----------Internal Error: $e');
    }
  }

  void resetProvider() {
    imagePath = "";
    linkImageFireStorage = "";
    linkQR = "";
    qrHistory = [];
    detectBox = null;
    isDetect = false;
    isDetectSuccess = false;
    isOcrSuccess = false;
    listNumplate = [];
    listNumplateText = [];
    notifyListeners();
  }
}
