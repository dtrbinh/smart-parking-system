import 'package:cloud_firestore/cloud_firestore.dart';

class Parker {
  late String parkerID;
  late String plateNumber;
  late Timestamp? checkIn;
  late Timestamp? checkOut;
  late String imageURL;
  late String qrURL;
  late bool isCheckOut;

  Parker(this.parkerID, this.plateNumber, this.imageURL, this.qrURL) {
    isCheckOut = false;
    checkIn = Timestamp.now();
    checkOut = null;
  }

  Map<String, dynamic> toJson() => {
        'parkerID': parkerID,
        'plateNumber': plateNumber,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'imageURL': imageURL,
        'qrURL': qrURL,
        'isCheckOut': isCheckOut,
      };

  Parker.fromJson(Map<String, dynamic> parseJson) {
    parkerID = parseJson['parkerID'];
    plateNumber = parseJson['plateNumber'];
    checkIn = parseJson['checkIn'];
    checkOut = parseJson['checkOut'];
    imageURL = parseJson['imageURL'];
    qrURL = parseJson['qrURL'];
    isCheckOut = parseJson['isCheckOut'] as bool;
  }
}
