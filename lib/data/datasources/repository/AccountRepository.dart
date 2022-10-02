import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';
import '../service/FirebaseService.dart';

class AccountRepository {
  static final AccountRepository _instance = AccountRepository();

  static AccountRepository get instance => _instance;

  User? user;
  FirebaseService firebaseService = FirebaseService();

  AccountRepository() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future<bool> handleSignIn() async {
    try {
      user = await firebaseService.signInWithGoogle();
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> handleSignOut() async {
    try {
      // googleSignIn.disconnect();
      await firebaseService.signOutFromGoogle();
      return true;
    } catch (error, stackTrace) {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
