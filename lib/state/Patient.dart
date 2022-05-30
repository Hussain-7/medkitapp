import 'package:medkitappD/state/Doctor.dart';

class PatientDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<String> providerData;

  PatientDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderPatientDetails {
  ProviderPatientDetails(this.providerDetails);
  final String providerDetails;
}


