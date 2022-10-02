import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/core/constants/pallete.dart';
import 'package:smart_parking_system/data/provider/CameraProvider.dart';
import 'package:smart_parking_system/data/provider/QRProvider.dart';
import 'package:smart_parking_system/data/provider/GuardProvider.dart';
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
          create: (context) => GuardProvider(),
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
          primaryColor: Colors.black,
          primarySwatch: primaryBlack,
        ),
        home: const LoginView(),
      ),
    );
  }
}
