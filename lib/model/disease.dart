import 'package:medkitapp/model/prescription.dart';
import 'package:medkitapp/state/Doctor.dart';
import 'package:flutter/foundation.dart';

class Disease {
  String uid;
  List<Perscription> perscriptions;
  String name;

  Disease({
    this.uid,
    this.perscriptions,
    this.name,
  });

  // receiving data from server
  factory Disease.fromMap(map) {
    return Disease(
      uid: map['uid'],
      perscriptions: map['perscriptions'],
      name: map['name'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'perscriptions': perscriptions,
      'name': name,
    };
  }
}
