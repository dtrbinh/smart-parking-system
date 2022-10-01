import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/features/manager/ManagerViewModel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    if (mounted) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Tổng số lượt check in:"),
                    Text("Tổng số lượt check out:"),
                    Text("Trường hợp báo mất vé xe:"),
                    Text("Đã giải quyết báo mất:"),
                    Text("Chưa giải quyết báo mất:"),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Tổng thu:"),
                  ]),
              const SizedBox(
                width: 20,
              ),
              Consumer(
                builder: (context, value, child) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            Provider.of<ManagerViewModel>(context, listen: true)
                                .totalCheckIn
                                .toString()),
                        Text(
                            Provider.of<ManagerViewModel>(context, listen: true)
                                .totalCheckOut
                                .toString()),
                        const Text("0"),
                        const Text("0"),
                        const Text("0"),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            Provider.of<ManagerViewModel>(context, listen: true)
                                .totalIncome
                                .toString()),
                      ]);
                },
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: Provider.of<ManagerViewModel>(context, listen: true)
              .data
              .selectedManagerType,
          onTap: (int index) {
            if (mounted) {
              Provider.of<ManagerViewModel>(context, listen: false)
                  .changeManagerType(index);
              Provider.of<ManagerViewModel>(context, listen: false).loadData();
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.today), label: "Day"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: "Month"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Year"),
          ]),
    );
  }
}
