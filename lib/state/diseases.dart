import 'package:flutter/foundation.dart';
import 'package:medkitapp/model/disease.dart';

class Diseases with ChangeNotifier {
  List<Disease> _diseases = [];

  List<dynamic> get diseases {
    return diseases;
  }

  int get itemCount {
    return _diseases.length;
  }

  // set for disease
  void set diseases(List<Disease> diseases) {
    _diseases = diseases;
    notifyListeners();
  }

  void addDisease(Disease disease) {
    // _diseases.add(disease);
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
}
