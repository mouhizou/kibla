import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kibla/database/ptdata.dart';

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

  final String url =
      'https://api.aladhan.com/v1/timingsByCity/09-03-2024?city=Setif&country=Algeria';

  Future<Data> getPTDATA() async {
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
          future: futurePTData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                children: [
                  Text('fadhjer   :'+snapshot.data!.data.timings.fajr),

                ],
              );
            }
          },
        ),
      ),
    );
  }
}
