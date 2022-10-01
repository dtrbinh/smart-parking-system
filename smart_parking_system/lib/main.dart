import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_parking_system/features/SPSApp.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';
import 'firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: "assets/roboflow.env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e, stackTrace) {
    logError('----------Internal Error: $e');
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
    );
  }
  await SentryFlutter.init(
        (options) {
      options.dsn = dotenv.env['SENTRY_DNS']!;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const SPSApp()),
  );

}
