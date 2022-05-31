import 'package:flutter/foundation.dart';
import 'package:medkitapp/model/disease.dart';
import 'package:medkitapp/model/prescription.dart';

class Perscriptions with ChangeNotifier {
  List<Perscription> _prescriptions;

  List<Perscription> get prescriptions {
    return prescriptions;
  }

  int get itemCount {
    return _prescriptions.length;
  }

  void set prescriptions(List<Perscription> prescriptions) {
    _prescriptions = prescriptions;
    notifyListeners();
  }

  void addPerscription(Perscription perscription) {
    _prescriptions.add(Perscription(
      uid: perscription.uid,
      medicine: perscription.medicine,
      dose: perscription.dose,
      description: perscription.description,
      doctorId: perscription.doctorId,
    ));
    notifyListeners();
  }

  void removePerscription(Perscription perscription) {
    _prescriptions.remove(perscription);
    notifyListeners();
  }

  void clear() {
    _prescriptions = [];
    notifyListeners();
  }
}
