import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Doctor with ChangeNotifier {
  String uid;
  List<dynamic> _diseases = [
    // "Backache",
    // "Chalazion",
    // "Diarrhea",
    // "Earache",
    // "Epistaxis",
    // "Fever",
    // "Headache",
    // "Hiccups",
    // "Laryngitis",
    // "Loss of taste or smell",
  ];
  Doctor({this.uid});

  List<dynamic> get diseases {
    return _diseases;
  }

  int get itemCount {
    return _diseases.length;
  }

  // set for disease
  void set diseases(List<dynamic> diseases) {
    _diseases = diseases;
    notifyListeners();
  }

  void addDisease(String disease) {
    _diseases.add(disease);
    notifyListeners();
  }

  void removeDisease(String disease) {
    _diseases.remove(disease);
    notifyListeners();
  }

  void clear() {
    _diseases = [];
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'diseases': _diseases,
    };
  }
}
