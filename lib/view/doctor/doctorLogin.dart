// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medkitapp/state/Doctor.dart';
import 'package:medkitapp/state/google_sign_in.dart';
import 'package:medkitapp/model/user.dart';
import 'package:medkitapp/view/animations/bottomAnimation.dart';
import 'package:medkitapp/view/doctor/doctorPanel.dart';
import 'package:medkitapp/view/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:provider/provider.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DoctorLogin extends StatefulWidget {
  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

final _controllerName = TextEditingController();
final _controllerPhone = TextEditingController();
final _controllerCNIC = TextEditingController();

class _DoctorLoginState extends State<DoctorLogin> {
  //bool validatePhoneVar = false;
  bool validateCNICVar = false;
  bool validateName = false;
  final _auth = FirebaseAuth.instance;
  String documentsPath = '';
  String tempPath = '';
  File myFile;
  String fileText = '';

  controllerClear() {
    _controllerName.clear();
    _controllerPhone.clear();
    _controllerCNIC.clear();
  }

  validateCNIC(String idNumber) {
    if (!(idNumber.length == 13) && idNumber.isNotEmpty) {
      return "CNIC must be of 13-Digits";
    }
    return null;
  }

  final pwdController = TextEditingController();

  final storage = FlutterSecureStorage();

  Future writeToSecureStorage(String uid) async {
    pwdController.clear();
    await storage.write(key: uid, value: "doctor");
  }

  Future<String> readFromSecureStorage(String uid) async {
    String secret = await storage.read(key: uid);
    return secret;
  }

  createUserInFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.name = _controllerName.text;
    userModel.cnic = _controllerCNIC.text;
    userModel.type = "doctor";

    writeToSecureStorage(user.uid);

    await getPaths();
    myFile = File('$documentsPath/loginData.txt');
    await writeFile(_controllerName.text, _controllerCNIC.text);

    // get user by email
    DocumentSnapshot userSnapshot =
        await firebaseFirestore.collection("users").doc(user.uid).get();
    print("querying user");
    print(userSnapshot.exists);
    if (!userSnapshot.exists) {
      print("user does not exist");
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());

      await firebaseFirestore
          .collection("doctorDetails")
          .doc(user.uid)
          .set(new Doctor(uid: user.uid).toMap());
      Fluttertoast.showToast(msg: "Account created successfully :) ");
    }
    Fluttertoast.showToast(msg: "Logged in successfully :) ");
  }

  Future getPaths() async {
    // Data in this dir is permanantly stored on the device.
    final docDir = await getApplicationDocumentsDirectory();
    // Data in this directory is deleted when the app is closed.
    // Usually used for session storage.
    final tempDir = await getTemporaryDirectory();
    setState(() {
      documentsPath = docDir.path;
      tempPath = tempDir.path;
    });
  }

  Future<bool> writeFile(String name, String cnic) async {
    try {
      await myFile.writeAsString('${name},${cnic}');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> readFile() async {
    try {
      // Read the file.
      String fileContent = await myFile.readAsString();
      setState(() {
        fileText = fileContent;
      });
      String name = fileText.split(',')[0];
      String cnic = fileText.split(',')[1];
      _controllerName.text = name;
      _controllerCNIC.text = cnic;
      print(fileText);
      return true;
    } catch (e) {
      // On error, return false.
      return false;
    }
  }

  @override
  void initState() {
    getPaths().then((_) {
      myFile = File('$documentsPath/loginData.txt');
      readFile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final nameTextField = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLength: 30,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      controller: _controllerName,
      decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(0.07),
          filled: true,
          labelText: 'Enter Name',
          prefixIcon: WidgetAnimator(Icon(Icons.person)),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(20)))),
    );

    final cnicTextField = TextField(
      keyboardType: TextInputType.number,
      autofocus: false,
      maxLength: 13,
      controller: _controllerCNIC,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
          filled: true,
          errorText: validateCNIC(_controllerCNIC.text),
          fillColor: Colors.black.withOpacity(0.07),
          labelText: 'NIC Number',
          prefixIcon: WidgetAnimator(Icon(Icons.credit_card)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );

    getInfoAndLogin() async {
      if (validateCNIC(_controllerCNIC.text) != null) return;
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.googleLogin();
      await createUserInFirestore();
      // ProviderDoctorDetails providerInfo =
      //     new ProviderDoctorDetails(userDetails.providerId);

      // List<ProviderDoctorDetails> providerData =
      //     new List<ProviderDoctorDetails>();
      // providerData.add(providerInfo);

      // DoctorDetails details = new DoctorDetails(
      //   userDetails.providerId,
      //   userDetails.displayName,
      //   userDetails.photoUrl,
      //   userDetails.email,
      //   providerData,
      // );
      print(_controllerName.text);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => DoctorPanel()));
    }

    Widget LoginScreen = GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              width: width,
              height: height,
              child: Stack(
                children: <Widget>[
                  BackBtn(),
                  ImageAvatar(
                    assetImage: 'assets/bigDoc.png',
                  ),
                  Container(
                    width: width,
                    height: height,
                    margin:
                        EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Text(
                          "\t\tLogin",
                          style: GoogleFonts.abel(
                              fontSize: height * 0.044,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        nameTextField,
                        //phoneTextField,
                        cnicTextField,
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width,
                          height: height * 0.07,
                          child: RaisedButton(
                            color: Colors.white,
                            shape: StadiumBorder(),
                            onPressed: () {
                              setState(() {
                                _controllerCNIC.text.isEmpty
                                    ? validateCNICVar = true
                                    : validateCNICVar = false;
                                _controllerName.text.isEmpty
                                    ? validateName = true
                                    : validateName = false;
                              });
                              !validateName & !validateCNICVar
                                  ? getInfoAndLogin()
                                  : Fluttertoast.showToast(
                                      msg: "Empty Field(s) Found!",
                                      backgroundColor: Colors.red,
                                    );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                WidgetAnimator(
                                  Image(
                                    image: AssetImage('assets/google.png'),
                                    height: height * 0.035,
                                  ),
                                ),
                                SizedBox(width: height * 0.015),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.022),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       Text("Already have an account? "),
                        //       GestureDetector(
                        //         onTap: () {
                        //           // Navigator.push(
                        //           //     context,
                        //           //     MaterialPageRoute(
                        //           //         builder: (context) =>
                        //           //             RegistrationScreen()
                        //           //             )
                        //           // );
                        //         },
                        //         child: Text(
                        //           "Login",
                        //           style: TextStyle(
                        //               color: Colors.redAccent,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 15),
                        //         ),
                        //       )
                        //     ]),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        WidgetAnimator(
                          Text(
                            'You Will be asked Question regarding your Qualifications!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.2,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
    return LoginScreen;
    // StreamBuilder(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if (snapshot.hasData) {
    //         return DoctorPanel(
    //           detailsUser: new DoctorDetails(
    //               "final String providerDetails",
    //               _controllerName.text,
    //               "https://st2.depositphotos.com/4226061/9064/v/950/depositphotos_90647784-stock-illustration-male-doctor-avatar-icon.jpg",
    //               "Username", [
    //             new ProviderDoctorDetails("provider 1"),
    //             new ProviderDoctorDetails("provider 2"),
    //           ]),
    //         );
    //       } else {
    //         return LoginScreen;
    //       }
    //     });
  }
}
