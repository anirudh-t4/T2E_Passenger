import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';


class barmain extends StatefulWidget {
  @override
  _barmainState createState() => _barmainState();
}

class _barmainState extends State<barmain> {
  String result;
  Future _scanQR() async {
    try {
      String cameraScanResult = await scanner.scan();

      await setState(() {
        result = cameraScanResult;
        // setting string result with cameraScanResult
        
      });
    } on PlatformException catch (e) {
      // log(e);
      log(e.toString());
    }
  }

  Future _scanQRGallery() async {
    try {
      String cameraScanResult = await scanner.scanPhoto();

      await setState(() {
        result = cameraScanResult;
        // setting string result with cameraScanResult
      });
    } on PlatformException catch (e) {
      // log(e);
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "QR Scanner",
            style: TextStyle(fontFamily: "Philosopher", fontSize: 30),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height / 19),
          Center(
            child: GestureDetector(
                onTap: () {
                  AlertDialog alert = AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Select Type",
                      style: TextStyle(
                          color: Colors.black, fontFamily: "Philosopher"),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                _scanQR();
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.camera,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontFamily: "Philosopher"),
                                  )
                                ],
                              )),
                          SizedBox(height: 20),
                          GestureDetector(
                              onTap: () {
                                _scanQRGallery();
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontFamily: "Philosopher"),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Card(
                        color: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 10,
                        child: Center(
                          child: Text(
                            "Scan",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: "Philosopher"),
                          ),
                        )))),
          ),
        ],
      ),
    );
  }
}