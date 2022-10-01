import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/data/provider/camera_provider.dart';
import 'package:smart_parking_system/data/provider/qr_scanner_provider.dart';
import 'package:smart_parking_system/data/provider/storage_provider.dart';
import 'package:smart_parking_system/features/guard/GuardViewModel.dart';
import 'package:smart_parking_system/features/login_screen/LoginView.dart';
import 'package:smart_parking_system/features/manager/ManagerViewModel.dart';
class SPSApp extends StatelessWidget {
  const SPSApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GuardViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagerViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CameraProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StorageProvider(),
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
        home: const LoginView(),
      ),
    );
  }
}
