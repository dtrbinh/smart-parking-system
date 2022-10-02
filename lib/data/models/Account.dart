import 'package:cloud_firestore/cloud_firestore.dart';
import 'Company.dart';

class Account {
  late Company company;
  late String accountType;
  late String accountID;
  String? email;
  late String username;
  late String password;
  Timestamp? createdAt = Timestamp.now();
  late Timestamp? updatedAt;
  Account({
    required this.company,
    required this.accountType,
    required this.accountID,
    required this.username,
    required this.password,
    this.email,
    this.createdAt,
    this.updatedAt,
  });
}
