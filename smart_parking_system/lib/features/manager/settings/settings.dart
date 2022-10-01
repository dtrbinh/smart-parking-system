import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/features/manager/ManagerViewModel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Set Parking Fee",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: Provider.of<ManagerViewModel>(context, listen: true)
                  .data
                  .parkingFee
                  .toString(),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              if (value != "") {
                Provider.of<ManagerViewModel>(context, listen: false)
                    .changeParkingFee(double.parse(value));
              }
              FocusManager.instance.primaryFocus!.unfocus();
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
