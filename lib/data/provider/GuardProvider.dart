import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smart_parking_system/data/datasources/repository/GuardRepository.dart';
import 'package:smart_parking_system/data/models/DetectBox.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';

import '../datasources/repository/AccountRepository.dart';

class GuardProvider extends ChangeNotifier {
  GuardRepository guardRepository = GuardRepository.instance;
  AccountRepository accountRepository = AccountRepository.instance;
  void uploadImage() async {
    //upload to cloud storage-> get link image -> generate qr -> detect numplate -> delete local image
    await guardRepository.postImage();
    try {
      getNumplate();
    } catch (error, stackTrace) {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }
    notifyListeners();
  }

  void uploadData() async {
    await guardRepository.postData();
  }

  void getNumplate() async {
    await http
        .get(Uri.parse(dotenv.env['ROBOFLOW_MODEL_URL_V4']!)
            .replace(queryParameters: {
      'api_key': dotenv.env['ROBOFLOW_API_KEY'],
      'image': guardRepository.linkImageFireStorage,
      'confidence': '0.7',
    }))
        .then((response) async {
      logWarning(response.body);
      guardRepository.detectBox =
          DetectBox.fromJson(json.decode(response.body));
      await cropNumplateFrame();
      await ocrScan();
    }, onError: (error, stackTrace) async {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      deleteImageCache(File(guardRepository.imagePath));
    });
  }

  void generateQR() {
    if (guardRepository.isDetectSuccess) {
      guardRepository.linkQR =
          "http://api.qrserver.com/v1/create-qr-code/?data=${guardRepository.linkImageFireStorage}&size=400x400";
      guardRepository.qrHistory.add(guardRepository.linkQR);
    } else {
      guardRepository.linkQR = '';
    }
    notifyListeners();
  }

  Future<void> cropNumplateFrame() async {
    try {
      for (int i = 0; i < guardRepository.detectBox!.predictions.length; i++) {
        var numplate = await FlutterNativeImage.cropImage(
          guardRepository.imagePath,
          guardRepository.detectBox!.predictions[i].x.toInt() -
              guardRepository.detectBox!.predictions[i].width ~/ 2,
          guardRepository.detectBox!.predictions[i].y.toInt() -
              guardRepository.detectBox!.predictions[i].height ~/ 2,
          guardRepository.detectBox!.predictions[i].width,
          guardRepository.detectBox!.predictions[i].height,
        );
        guardRepository.listNumplate.add(numplate);
        logWarning(
            '------------Model detected ${i + 1} numplate: ${guardRepository.listNumplate[i].path}');
      }
      if (guardRepository.listNumplate.isNotEmpty) {
        guardRepository.isDetectSuccess = true;
      } else {
        guardRepository.isDetectSuccess = false;
      }
    } catch (e, stackTrace) {
      guardRepository.isDetectSuccess = false;
      logError('----------Internal Error: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    } finally {
      guardRepository.isDetect = true;
      deleteImageCache(File(guardRepository.imagePath));
      notifyListeners();
    }
  }

  Future<void> ocrScan() async {
    try {
      if (guardRepository.isDetectSuccess) {
        final textRecognizer =
            TextRecognizer(script: TextRecognitionScript.latin);
        for (int i = 0; i < guardRepository.listNumplate.length; i++) {
          final RecognizedText recognizedText =
              await textRecognizer.processImage(
                  InputImage.fromFile(guardRepository.listNumplate[i]));
          String result = "";
          // String allText = recognizedText.text;
          // logWarning(allText);
          for (TextBlock block in recognizedText.blocks) {
            //each block of text/section of text
            // final String text = block.text;
            // logWarning("Block of text: $text");
            for (TextLine line in block.lines) {
              //each line within a text block
              for (TextElement element in line.elements) {
                //each word within a line
                result += "${element.text} ";
              }
            }
          }
          //result += "\n\n";
          guardRepository.listNumplateText.add(result);
          logWarning("----------Detect result: $result.");
        }
        textRecognizer.close();
        guardRepository.isDetectSuccess = true;
        generateQR();
        uploadData();
        //scan image
      } else {
        guardRepository.isDetectSuccess = false;
        logError('----------Internal Error: No image to scan.');
        guardRepository.deleteImage(guardRepository.linkImageFireStorage);
        await Sentry.captureException(
          Exception("No image to scan"),
          stackTrace: "No stack trace",
        );
      }
    } catch (e, stackTrace) {
      guardRepository.isDetectSuccess = false;
      logError('----------Internal Error: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    } finally {
      notifyListeners();
      //Delete temp file save image
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        for (int i = 0; i < guardRepository.listNumplate.length; i++) {
          deleteImageCache(guardRepository.listNumplate[i]);
        }
      });
    }
  }

  Future<void> deleteImageCache(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        logWarning('------------Deleted picture: ${file.path}');
      } else {
        logError('----------Internal Error: File not exists.');
        await Sentry.captureException(
          Exception("File to delete not exists"),
          stackTrace: null,
        );
      }
    } catch (e, stackTrace) {
      logError('----------Internal Error: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  void resetProvider() {
    guardRepository = GuardRepository.instance;
    notifyListeners();
  }
}
