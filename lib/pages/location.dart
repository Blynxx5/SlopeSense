import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:slopesense/models/global_favourites.dart';
import 'package:slopesense/pages/full_screen_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LocationPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic> forecastWeather;

  const LocationPage(
      {Key? key, required this.weatherData, required this.forecastWeather}): super(key: key);


Future<void> addFavoriteLocation(String location) async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    DocumentReference userDoc = FirebaseFirestore.instance.collection('Favourites').doc(currentUser.uid);
    await userDoc.update({
      'Location': FieldValue.arrayUnion([location])
    });
  }
}   

  @override
  Widget build(BuildContext context) {
    String latitudeString = weatherData['lat'] ?? '0.0';
    String longitudeString = weatherData['lon'] ?? '0.0';


    // Creating lists to hold the days of each element in the data map
    // adding this data and converting it to a string, to represent the day e.g. Tuesday
    List<String> dates = [];
    List<String> minTemps = [];
    List<String> maxTemps = [];
    List<String> avgTemps = [];
    List<String> totalSnows = [];

    List<dynamic> forecastData = forecastWeather['data'] as List<dynamic>? ?? [];

    for (var data in forecastData) {
      DateTime dateTime = DateTime.parse(data['date']);
      String dayString = DateFormat('EEEE').format(dateTime);
      dates.add(dayString);

      String minTemp = data['mintemp'].toString();
      minTemps.add(minTemp);

      String maxTemp = data['maxtemp'].toString();
      maxTemps.add(maxTemp);

      String avgTemp = data['avgtemp'].toString();
      avgTemps.add(avgTemp);

      String totalSnow = data['totalsnow'].toString();
      totalSnows.add(totalSnow);
    }

    double latitude, longitude;

    try {
      latitude = double.parse(latitudeString);
      longitude = double.parse(longitudeString);
    } catch (e) {
      print('Error parsing latitude or longitude: $e');
      latitude = 0.0;
      longitude = 0.0;
    }

    return Scaffold(
      backgroundColor: Color(0xFFC0DEE5),
      appBar: AppBar(
        backgroundColor: Color(0xFFC0DEE5),
        title: Text('${weatherData['name']}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 13,
                  ),
                  mapType: MapType.hybrid,
                  markers: {
                    Marker(
                      markerId: MarkerId('locationMarker'),
                      position: LatLng(latitude, longitude),
                      infoWindow: InfoWindow(title: '${weatherData['name']}'),
                    ),
                  },
                ),
              ),
              SizedBox(width: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullscreenMapPage(
                            latitude: latitude,
                            longitude: longitude,
                          ),
                        ),
                      );
                    },
                    child: Text('Expand'),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                ),
                child: ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      title: Row(
                        children: [
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('${dates[index]}'),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${totalSnows[index]} %',
                                ),
                                SizedBox(width: 8.0),
                                Icon(
                                  Icons.ac_unit,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${maxTemps[index]}'),
                                SizedBox(width: 8.0),
                                Text(
                                  '${minTemps[index]}',
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(      
                    onPressed: () {
                      addFavoriteLocation('${weatherData['name']}');
                      //saves the name of the location that is in the app bar, this is to be later used in the favourites page:
                      if (!GlobalFavouites()
                          .locationNames
                          .contains('${weatherData['name']}')) {
                        GlobalFavouites()
                            .locationNames
                            .add('${weatherData['name']}');
                      }
                      print(GlobalFavouites()
                          .locationNames); // To verify it's saved
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 40),
                    ),
                    child: Icon(Icons.add),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
