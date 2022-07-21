import 'package:flutter/cupertino.dart';
import 'package:smart_parking_system/src/data/models/manager_data.dart';
import 'package:smart_parking_system/src/modules/login_screen/login_screen.dart';
import 'package:smart_parking_system/src/modules/manager/dashboard.dart';
import 'package:smart_parking_system/src/modules/manager/settings.dart';
import 'package:smart_parking_system/src/modules/manager/today_report.dart';

class ManagerRouterProvider extends ChangeNotifier {
  int selectedIndex = 0;

  ManagerData data = ManagerData();
  int totalCheckIn = 0;
  int totalCheckOut = 0;
  double totalIncome = 0;

  void changeManagerType(int index) {
    data.selectedManagerType = index;
    notifyListeners();
  }

  void changeParkingFee(double value) {
    data.parkingFee = value;
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal() {
    totalCheckIn = 0;
    totalCheckOut = 0;
    totalIncome = 0;
    for (var parker in data.resultData) {
      if (parker.isCheckOut) {
        totalCheckIn++;
        totalCheckOut++;
      } else {
        totalCheckIn++;
      }
    }
    totalIncome = totalCheckOut * data.parkingFee;
    notifyListeners();
  }

  Future<void> loadData() async {
    await data.getData();
    calculateTotal();
    notifyListeners();
  }

  void changeSelectedIndex(int value) {
    selectedIndex = value;
    notifyListeners();
  }

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TodayReportScreen();
      case 2:
        return const SettingsScreen();
      default:
        return const LoginScreen();
    }
  }

  void resetProvider() {
    notifyListeners();
  }
}
