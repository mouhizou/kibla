import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
class kibla extends StatefulWidget {
  const kibla({super.key});

  @override
  State<kibla> createState() => _kiblaState();
}

class _kiblaState extends State<kibla> {
  bool _hasepermesion = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchprmessionstatuse();
  }
  void _fetchprmessionstatuse(){
    Permission.locationWhenInUse.status.then((status) {
      if(mounted){
        setState(() {
          _hasepermesion = (status == PermissionStatus.granted);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context){
          if(_hasepermesion ){
            return builedcompas();
          }else{
            return buildpermissionshet();
          }
        },
      ),
    );
  }
  Widget buildpermissionshet(){
    return Center(
      child: ElevatedButton(
        child: const Text('ask for mermession to use compas'),
        onPressed: (){
          Permission.locationWhenInUse.request().then((value) {
            _fetchprmessionstatuse();
          });
        },
      ),
    );
  }
  Widget builedcompas(){
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );

        return Material(
          shape: CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Transform.rotate(
              angle: (direction * (pi / 180) * -1),
              child: Image.asset('lib/images/compass.png'),
            ),
          ),
        );
      },
    );
  }
}
