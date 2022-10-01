import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/features/manager/ManagerViewModel.dart';

class ManagerView extends StatefulWidget {
  const ManagerView({Key? key}) : super(key: key);

  @override
  State<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
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
                    Provider.of<ManagerViewModel>(context, listen: true)
                        .selectedIndex,
                onTap: (int index) {
                  Provider.of<ManagerViewModel>(context, listen: false)
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
                    Provider.of<ManagerViewModel>(context, listen: false)
                        .getBody())));
  }
}
