import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AgeScreen extends StatefulWidget {
  final Function(int) onChanged;

  AgeScreen({@required this.onChanged});

  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  dynamic age = 0;
  dynamic result;

  void chkper() async{
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
    }

  }

  

  Future _scanQR() async {
    try {
     dynamic cameraScanResult = await scanner.scan();

      await setState(() {
        result = cameraScanResult;
        // setting string result with cameraScanResult
        age=int.parse(result);
        widget.onChanged(int.parse(result));
        
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
        age=int.parse(result);
        widget.onChanged(int.parse(result));
        // setting string result with cameraScanResult
      });
    } on PlatformException catch (e) {
      // log(e);
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                'Seat No. is',
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
        Expanded(
          child: age==0?Column(
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
                              chkper();
                              setState(() {
                                _scanQR();
                              });
                                
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
                            "Scan Ticket",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: "Philosopher"),
                          ),
                        )))),
          ),
        ],
      ):Center(child:Text(age.toString(),style: TextStyle(fontSize: 40.0),)),
        )],
    );
  }
}
