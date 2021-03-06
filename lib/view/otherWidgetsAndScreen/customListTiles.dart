import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medkitapp/state/Doctor.dart';
import 'package:medkitapp/view/otherWidgetsAndScreen/medDetails.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CustomTile extends StatefulWidget {
  final bool delBtn;
  final String disease;
  final Function removeDisease;
  CustomTile({this.delBtn, this.disease, this.removeDisease});

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  _deleteDisease(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DeletingWait(widget.disease, widget.removeDisease)));
  }

  @override
  Widget build(BuildContext context) {
    print("delete:");
    print(widget.delBtn);
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     new MaterialPageRoute(
        //         builder: (context) => MedDetails(
        //               snapshot: widget.snapshot,
        //             )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        height: height * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: new LinearGradient(colors: [
            Colors.white.withOpacity(0.8),
            !widget.delBtn
                ? Colors.blueGrey.withOpacity(0.2)
                : Colors.redAccent.withOpacity(0.2),
          ]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.disease,
              style:
                  GoogleFonts.lato(fontSize: height * 0.03, letterSpacing: 2),
            ),
            FlatButton(
              onPressed: () {
                if (widget.delBtn) {
                  _deleteDisease(context);
                } else {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => MedDetails()));
                }
              },
              shape: CircleBorder(),
              child: widget.delBtn
                  ? Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: height * 0.032,
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black54,
                      size: height * 0.032,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class DeletingWait extends StatelessWidget {
  final String diseaseName;
  final Function removeDisease;
  DeletingWait(this.diseaseName, this.removeDisease);
  @override
  Widget build(BuildContext context) {
    final diseaseName = ModalRoute.of(context).settings.arguments as String;
    Future.delayed(Duration(seconds: 2), () {
      print("disease : ${diseaseName}");
      removeDisease();
      Navigator.pop(context);
      // Toast.show("Deleted Successfully!", context,
      //     backgroundRadius: 5, backgroundColor: Colors.red, duration: 3);
    });
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'Deleting Please Wait...',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
