import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';


class LocationPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic> forecastWeather;

  const LocationPage(
      {Key? key, required this.weatherData, required this.forecastWeather})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String latitudeString = weatherData['lat'] ?? '0.0';
    String longitudeString = weatherData['lon'] ?? '0.0';

    String locationName;

    // Creating lists to hold the days of each element in the data map
    // adding this data and converting it to a string, to represent the day e.g. Tuesday
    List<String> dates = [];
    List<String> minTemps = [];
    List<String> maxTemps = [];
    List<String> avgTemps = [];
    List<String> totalSnows = [];

    List<dynamic> forecastData = forecastWeather['data'] as List<dynamic>;

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
      appBar: AppBar(
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
                  mapType: MapType.terrain,
                  markers: {
                    Marker(
                      markerId: MarkerId('locationMarker'),
                      position: LatLng(latitude, longitude),
                      infoWindow: InfoWindow(title: '${weatherData['name']}'),
                    ),
                  },
                ),
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
                      //saves the name of the location that is in the app bar, this is to be later used in the favourites page:
                     locationName = '${weatherData['name']}';
                     print(locationName);
                    },
                    style: ElevatedButton.styleFrom(
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
