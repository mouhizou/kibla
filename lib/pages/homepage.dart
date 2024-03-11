import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kibla/database/ptdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late Future<Data> futurePTData;

  @override
  void initState() {
    super.initState();

    futurePTData = getPTDATA();
  }
  static String? city='algeria';
  static String? cuntry='algeria';


  Future<Data> getPTDATA() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    city = placemarks[0].locality.toString();
    cuntry = placemarks[0].country.toString();
    final String url =
        'http://api.aladhan.com/v1/timingsByCity/11-03-2024?city=$city&country=$cuntry';
    Uri uri = Uri.parse(url);
    http.Response res = await http.get(uri,
        headers: {"Accept": "text/html,application/xml;q=0.9,image/webp,*/*;q=0.8"});

    final data = jsonDecode(res.body);
    return Data.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Data>(
          future: getPTDATA(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(25),
                      child: Text('$cuntry in $city'),
                    ),
                    Text('fadhjer   :'+snapshot.data!.data.timings.fajr),
                    Text('dhuhr   :'+snapshot.data!.data.timings.dhuhr),
                    Text('asr   :'+snapshot.data!.data.timings.asr),
                    Text('maghrib   :'+snapshot.data!.data.timings.maghrib),
                    Text('isha   :'+snapshot.data!.data.timings.isha),

                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
