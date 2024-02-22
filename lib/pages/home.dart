import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> weatherData = {};

  Future<void> fetchWeather(String location) async {
    final apiKey = 'c0a6cdd6c865202f7a7b2a57f7cbc944';
    final url = Uri.parse('http://api.weatherstack.com/current?access_key=$apiKey&query=$location');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Update the state with specific weather data
        setState(() {
          weatherData = {
            'temperature': jsonData['current']['temperature'],
            'wind_speed': jsonData['current']['wind_speed'],
            'wind_dir': jsonData['current']['wind_dir'],
          };
        });
      } else {
        // Handle errors
        setState(() {
          weatherData = {'error': 'Failed to fetch weather data. Status code: ${response.statusCode}'};
        });
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        weatherData = {'error': 'Exception during request: $e'};
      });
    }
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, left: 20, right: 20),
            child: TextField(
              onSubmitted: (value) {
                // Trigger weather data fetching when the user submits the search
                fetchWeather(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200], // Background color
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
                prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ),
          // Display specific weather data
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature: ${weatherData['temperature']}°C',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Wind Speed: ${weatherData['wind_speed']} m/s',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Wind Direction: ${weatherData['wind_dir']}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Home Page'),
      leading: GestureDetector(
        onTap: () {
          // Add your action here
          //This will change page to the Login page
            // Navigator.push(
            // //   context,
            // //   MaterialPageRoute(builder: (context) => Login()),
            // );
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/icons/chevron-left-svgrepo-com.svg',
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Add your action here
          },
          child: Container(
            margin: EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/list-svgrepo-com.svg',
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
