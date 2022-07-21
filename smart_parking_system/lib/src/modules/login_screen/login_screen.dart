import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/camera_provider.dart';
import 'package:smart_parking_system/src/modules/guard/guard.dart';
import 'package:smart_parking_system/src/modules/manager/manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: const Text("Smart Parking System")),
            body: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), label: Text("Username")),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), label: Text("Password")),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Provider.of<CameraProvider>(context, listen: false)
                            .initCamera();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => const Guard())));
                      },
                      child: const Text("Login Guard")),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        Provider.of<CameraProvider>(context, listen: false)
                            .initCamera();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => const Manager())));
                      },
                      child: const Text("Login Manager")),
                ],
              ),
            ))));
  }
}
