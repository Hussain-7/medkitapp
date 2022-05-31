class Perscription {
  String uid;
  String medicine;
  String dose;
  String description;
  String doctorId;

  Perscription(
      {this.uid, this.medicine, this.dose, this.description, this.doctorId});

  // receiving data from server
  factory Perscription.fromMap(map) {
    return Perscription(
      uid: map['uid'],
      medicine: map['medicine'],
      dose: map['dose'],
      description: map['description'],
      doctorId: map['doctorId'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': medicine,
      'name': dose,
      'cnic': description,
      'type': doctorId,
    };
  }
  
}
