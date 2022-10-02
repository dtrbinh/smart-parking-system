import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smart_parking_system/features/error/ErrorLogger.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e, stackTrace) {
      logError('----------Internal Error: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  Future<String?> createUserWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e, stackTrace) {
      logError('----------Internal Error: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return e.toString();
    }
    return null;
  }


  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (error, stackTrace) {
      logError('----------Internal Error: $error');
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }
  }
}
