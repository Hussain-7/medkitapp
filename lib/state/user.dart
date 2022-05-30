import 'package:medkitapp/state/Doctor.dart';

class UserModel {
  String uid;
  String email;
  String name;
  String cnic;
  String type;
  // Doctor? doctor;
  // Patient? patient;

  UserModel({this.uid, this.email, this.name, this.cnic, this.type});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      cnic: map['cnic'],
      type: map['type'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'cnic': cnic,
      'type': type,
    };
  }
}
