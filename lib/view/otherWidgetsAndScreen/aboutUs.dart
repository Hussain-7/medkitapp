import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'backBtnAndImage.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackBtn(),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'About Us',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: height * 0.07),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Developed By: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Syed Muhammmad Hussain Rizvi'
                        '\nMuhammad Bilal Afzal'
                        '\nMuhammad Kumail',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * 0.40,
                      ),
                      Image.network(
                        'https://nust.edu.pk/wp-content/uploads/2020/04/Logo1-277x300.jpg',
                        height: height * 0.1,
                      ),
                      Text('Nust University, Islamabad',
                          style: TextStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold)),
                      Text('@Copyrights All Rights Reserved, 2022',
                          style: TextStyle(fontSize: height * 0.02))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
