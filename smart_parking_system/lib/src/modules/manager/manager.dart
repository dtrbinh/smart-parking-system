import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/manager_router_provider.dart';

class Manager extends StatefulWidget {
  const Manager({Key? key}) : super(key: key);

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Smart Parking System"),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: const Icon(Icons.logout))
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex:
                    Provider.of<ManagerRouterProvider>(context, listen: true)
                        .selectedIndex,
                onTap: (int index) {
                  Provider.of<ManagerRouterProvider>(context, listen: false)
                      .changeSelectedIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard), label: "Dashboard"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.report), label: "Today Report"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ]),
            body: Consumer(
                builder: (context, value, child) =>
                    Provider.of<ManagerRouterProvider>(context, listen: false)
                        .getBody())));
  }
}
