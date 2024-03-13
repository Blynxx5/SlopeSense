import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:slopesense/pages/location.dart';
import 'dart:io';
import 'package:csv/csv.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> weatherData = {};

  bool shouldShowSuggestions = false;

  //allows me to change the state of the search box when clicking on a suggested value
  final TextEditingController controller = TextEditingController();

  Future<void> fetchWeather(String location) async {
    final apiKey = 'c0a6cdd6c865202f7a7b2a57f7cbc944';
    final url = Uri.parse(
        'http://api.weatherstack.com/current?access_key=$apiKey&query=$location');

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
            'name': jsonData['location']['name'],
            'lon': jsonData['location']['lon'],
            'lat': jsonData['location']['lat'],
          };
        });
      } else {
        // Handle errors
        setState(() {
          weatherData = {
            'error':
                'Failed to fetch weather data. Status code: ${response.statusCode}'
          };
        });
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        weatherData = {'error': 'Exception during request: $e'};
      });
    }
  }

  /*
      Making the list from the csv file to use for our suggestions
      in the typeahead field function
   */

    List<String> getSuggestions(String query) {
    List<String> suggestions = [];

    // Read the CSV file and split its content into lines
    List<String> lines =
        File('/Users/benlynch/DEV/slopesense/assets/resort_names.csv')
            .readAsStringSync()
            .split('\n');

    // Parse each line as a list and extract the first column
    for (String line in lines) {
      List<dynamic> row = CsvToListConverter().convert(line);
      if (row.isNotEmpty) {
        dynamic resortNameElement = row[0];
        String resortName = resortNameElement is List
            ? resortNameElement.first.toString()
            : resortNameElement.toString();

        if (resortName.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add(resortName);
        }
      }
    }

    return suggestions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: TypeAheadField<String>(
                controller: controller,
                hideOnEmpty: true,
                hideOnLoading: true,
                itemBuilder: (BuildContext context, String suggestion) {
                  // handle the selected suggestion
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSelected: (String? value) {
                  // Set the selected value to the controller
                  setState(() {
                    controller.text = value!;
                  });
                },
                suggestionsCallback: (String query) {
                  return shouldShowSuggestions ? getSuggestions(query) : [];
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    focusNode: focusNode,
                    controller: controller,
                    autofocus: true,
                    onChanged: (text) {
                      setState(() {
                        shouldShowSuggestions = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                      hintText: 'Search for European Ski resorts...',
                      hintStyle:
                          TextStyle(color: Colors.grey), // Hint text color
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey), // Search icon
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    onSubmitted: (value) {
                      // Trigger weather data fetching when the user submits the search
                      fetchWeather(value);
                    },
                  );
                },
              )),
          //adding distancd between the seach box container and the weather data container
          SizedBox(height: 20),
          // Display specific weather data
          if (weatherData.containsKey('temperature'))
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LocationPage(weatherData: weatherData)),
                );
              },
              child: Container(
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Column(
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
                      //creating space between the two columns
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print('hello');
                            },
                            child: Icon(Icons.add),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TextField suggestResort() {
    return TextField(
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
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('SlopeSense'),
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
