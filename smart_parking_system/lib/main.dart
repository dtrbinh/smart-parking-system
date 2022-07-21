import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/camera_provider.dart';
import 'package:smart_parking_system/src/data/provider/manager_router_provider.dart';
import 'package:smart_parking_system/src/data/provider/qr_scanner_provider.dart';
import 'package:smart_parking_system/src/data/provider/upload_firestorage_provider.dart';
import 'package:smart_parking_system/src/modules/login_screen/login_screen.dart';
import 'firebase_options.dart';
import 'src/data/provider/guard_route_provider.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GuardRouteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagerRouterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CameraProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FireStorageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScannerProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
