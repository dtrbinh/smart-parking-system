import 'package:cloud_firestore/cloud_firestore.dart';

class Parker {
  late String parkerID;
  late Timestamp checkIn;
  late Timestamp checkOut;
  late String imageURL;
  late String qrURL;
  late bool isCheckOut;
  Parker(this.parkerID, this.imageURL, this.qrURL) {
    isCheckOut = false;
    checkIn = Timestamp.now();
    checkOut = Timestamp(0, 0);
  }
  Map<String, dynamic> toJson() => {
        'parkerID': parkerID,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'imageURL': imageURL,
        'qrURL': qrURL,
        'isCheckOut': isCheckOut,
      };

  Parker.fromJson(Map<String, dynamic> parseJson) {
    parkerID = parseJson['parkerID'];
    checkIn = parseJson['checkIn'];
    checkOut = parseJson['checkOut'];
    imageURL = parseJson['imageURL'];
    qrURL = parseJson['qrURL'];
    isCheckOut = parseJson['isCheckOut'] as bool;
  }
}
