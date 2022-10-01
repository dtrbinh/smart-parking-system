import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_parking_system/features/SPSApp.dart';
import 'firebase_options.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: "assets/roboflow.env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e) {
    debugPrint('----------Internal Error: $e');
  }
  runApp(const SPSApp());
}
