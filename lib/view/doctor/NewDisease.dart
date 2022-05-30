import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medkitapp/state/Doctor.dart';
import 'package:provider/provider.dart';

class NewDisease extends StatefulWidget {
  @override
  State<NewDisease> createState() {
    print("createState NewTransaction Widget");
    return _NewDiseaseState();
  }
}

class _NewDiseaseState extends State<NewDisease> {
  final _titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void _submitData(Function addDisease) async {
    final enteredTitle = _titleController.text;
    final user = FirebaseAuth.instance.currentUser;
    final diseases = Provider.of<Doctor>(context, listen: false).diseases;
    if (enteredTitle.isEmpty) {
      return;
    }
    // Here add disease to firebase for this user
    await FirebaseFirestore.instance
        .collection("doctorDetails")
        .doc(user.uid)
        .update({
      "diseases": FieldValue.arrayUnion([...diseases, enteredTitle])
    });
    addDisease(
      _titleController.text,
    );
    // To close the bottom sheet after we pass input
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<Doctor>(context);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Disease Name'),
                  // onChanged: (String value) => titleInput = value
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(doctor.addDisease),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          primary: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor),
                      child: const Text("Add Disease"),
                      onPressed: () => _submitData(doctor.addDisease),
                    )),
                SizedBox(height: 100),
              ]),
        ),
      ),
    );
  }
}
