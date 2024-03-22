import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class FullscreenMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const FullscreenMapPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<FullscreenMapPage> createState() => _FullscreenMapPageState();
}

class _FullscreenMapPageState extends State<FullscreenMapPage> {
  String selectedOption = 'Hotels'; // Default to 'Hotels'
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: EdgeInsets.only(top: 14, left: 14, right: 6, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _optionButton('Hotels'),
                    SizedBox(width: 10),
                    _optionButton('Restaurants'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15,
        ),
        mapType: MapType.hybrid,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
      ),
    );
  }

  Widget _optionButton(String option) {
    return ElevatedButton(
      onPressed: () => _fetchPlaces(option),
      style: ElevatedButton.styleFrom(
        foregroundColor: selectedOption == option ? Colors.black : Colors.white, backgroundColor: selectedOption == option ? Colors.white : Colors.grey,
      ),
      child: Text(option),
    );
  }

  void _fetchPlaces(String option) async {
    setState(() {
      selectedOption = option;
    });

    const apiKey = 'AIzaSyDwkE4kVcHHw-cvsWPz0EC7EeEz0ZPpIy4';
    String type = option.toLowerCase();
    String location = '${widget.latitude},${widget.longitude}';
    String radius = '5000';
    String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$type&location=$location&radius=$radius&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> places = List<Map<String, dynamic>>.from(
          data['results'].map(
            (result) => {
              'name': result['name'],
              'address': result['formatted_address'] ?? 'No address provided',
              'lat': result['geometry']['location']['lat'],
              'lng': result['geometry']['location']['lng'],
            },
          ),
        );

        _showPlacesList(places);
      } else {
        print('Failed to fetch places: ${response.body}');
      }
    } catch (e) {
      print('Error fetching places: $e');
    }
  }

  void _showPlacesList(List<Map<String, dynamic>> places) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 500,
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            var place = places[index];
            return ListTile(
              title: Text(place['name']),
              subtitle: Text(place['address']),
              onTap: () {
                setState(() {
                  _markers.clear();
                  final selectedLocation = LatLng(place['lat'], place['lng']);
                  _markers.add(
                    Marker(
                      markerId: MarkerId('selectedPlace'),
                      position: selectedLocation,
                      infoWindow: InfoWindow(title: place['name'], snippet: place['address']),
                    ),
                  );
                  _mapController?.animateCamera(CameraUpdate.newLatLngZoom(selectedLocation, 15));
                });
                Navigator.pop(context); // Close the modal bottom sheet
              },
            );
          },
        ),
      ),
    );
  }
}
