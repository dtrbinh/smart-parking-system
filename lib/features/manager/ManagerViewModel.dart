import 'package:flutter/cupertino.dart';
import 'package:smart_parking_system/data/datasources/repository/ManagerRepository.dart';
import 'package:smart_parking_system/features/login_screen/LoginView.dart';
import 'package:smart_parking_system/features/manager/dashboard/dashboard.dart';
import 'package:smart_parking_system/features/manager/settings/settings.dart';
import 'package:smart_parking_system/features/manager/status_report/today_report.dart';

class ManagerViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  ManagerRepository data = ManagerRepository();
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
        return const LoginView();
    }
  }

  void resetProvider() {
    notifyListeners();
  }
}
