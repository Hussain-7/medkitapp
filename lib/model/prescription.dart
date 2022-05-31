class Perscription {
  String uid;
  String medicine;
  String dose;
  String description;
  String diseaseId;
  String doctorId;

  Perscription(
      {this.uid,
      this.medicine,
      this.dose,
      this.description,
      this.diseaseId,
      this.doctorId});

  // receiving data from server
  factory Perscription.fromMap(map) {
    return Perscription(
      uid: map['uid'],
      medicine: map['medicine'],
      dose: map['dose'],
      description: map['description'],
      diseaseId: map['diseaseId'],
      doctorId: map['doctorId'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'medicine': medicine,
      'dose': dose,
      'description': description,
      'diseaseId': diseaseId,
      'doctorId': doctorId,
    };
  }
}
