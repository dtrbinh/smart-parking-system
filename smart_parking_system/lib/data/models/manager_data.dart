import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_parking_system/data/models/parker.dart';

class ManagerData {
  int selectedManagerType = 0;
  double parkingFee = 0;
  List<Parker> resultData = [];
  List<Parker> filterCheckIn = [];
  List<Parker> filterCheckOut = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> getData() async {
    final fireStore = FirebaseFirestore.instance;
    resultData = [];
    filterCheckIn = [];
    filterCheckOut = [];
    switch (selectedManagerType) {
      case 0:
        startDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        endDate = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 23, 59, 59);
        break;
      case 1:
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 23, 59, 59);

        break;
      case 2:
        startDate = DateTime(DateTime.now().year, 1, 1);
        endDate = DateTime(DateTime.now().year, 12, 31, 23, 59, 59);
        break;
      default:
    }

    //Find all parker check in in this time
    final snapshot1 = await fireStore
        .collection("Parkers")
        .where("checkIn",
            isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();
    for (var item in snapshot1.docs) {
      filterCheckIn.add(Parker.fromJson(item.data()));
    }

    //Find all parker check out in this time
    final snapshot2 = await fireStore
        .collection("Parkers")
        .where('checkOut',
            isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();
    for (var item in snapshot2.docs) {
      filterCheckOut.add(Parker.fromJson(item.data()));
    }
    //Select distinct between two filter -> parker check in and check out in this time
    for (var item in filterCheckIn) {
      for (var i in filterCheckOut) {
        if (item.checkOut == i.checkOut) {
          resultData.add(item);
        }
      }
    }
  }
}
