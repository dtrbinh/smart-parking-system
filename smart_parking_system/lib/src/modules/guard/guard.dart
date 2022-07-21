import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/camera_provider.dart';
import 'package:smart_parking_system/src/data/provider/guard_route_provider.dart';
import 'package:smart_parking_system/src/data/provider/upload_firestorage_provider.dart';

class Guard extends StatefulWidget {
  const Guard({Key? key}) : super(key: key);

  @override
  State<Guard> createState() => _GuardState();
}

class _GuardState extends State<Guard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("System Manager"),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      try {
                        Provider.of<FireStorageProvider>(context, listen: false)
                            .deleteFile(File(Provider.of<FireStorageProvider>(
                                    context,
                                    listen: false)
                                .imagePath));
                        Provider.of<GuardRouteProvider>(context, listen: false)
                            .resetProvider();
                        Provider.of<CameraProvider>(context, listen: false)
                            .resetProvider();
                        Provider.of<FireStorageProvider>(context, listen: false)
                            .resetProvider();
                      } catch (e) {
                        // print(e.toString());
                      }
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: Provider.of<GuardRouteProvider>(context).selectedIndex,
                onTap: (int index) {
                  Provider.of<GuardRouteProvider>(context, listen: false)
                      .changeSelectedIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.input), label: "Check in"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.output), label: "Check out"),
                ]),
            body: Consumer(
              builder: (context, value, child) =>
                  Provider.of<GuardRouteProvider>(context).getBody(),
            )));
  }
}
