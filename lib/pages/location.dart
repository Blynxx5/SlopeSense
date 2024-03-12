import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const LocationPage({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract latitude and longitude from the weatherData
    String latitudeString = weatherData['lat'] ?? '0.0'; // Default to '0.0' if 'lat' is null
    String longitudeString = weatherData['lon'] ?? '0.0'; // Default to '0.0' if 'lon' is null

    // Convert to doubles with error handling
    double latitude, longitude;

    try {
      latitude = double.parse(latitudeString);
      longitude = double.parse(longitudeString);
    } catch (e) {
      print('Error parsing latitude or longitude: $e');
      // Handle the error, e.g., set default values or show an error message.
      // You might want to set default coordinates like (0.0, 0.0) in case of an error.
      latitude = 0.0;
      longitude = 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${weatherData['name']}'),
      ),
      body: Column(
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
                zoom: 10,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('locationMarker'),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(title: '${weatherData['name']}'),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}