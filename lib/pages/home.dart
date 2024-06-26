import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:slopesense/pages/Login.dart';
import 'package:slopesense/pages/favourites.dart';
import 'dart:convert';
import 'package:slopesense/pages/location.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Maps to allows for holding of both current and forecasted weather:
  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> forecastWeather = {};

  bool shouldShowSuggestions = false;

  // Allows me to change the state of the search box when clicking on a suggested value
  final TextEditingController controller = TextEditingController();

/*

    Fetch Weather function
      the following function fetched the current weather for the inputted value

      the following funciton also fetches the forecasted weather for the inputted value

  This is then available to the other pages to use this data how they want

*/
  Future<void> fetchWeather(String location) async {
    final apiKey = 'c0a6cdd6c865202f7a7b2a57f7cbc944';
    final urlCurrent = Uri.parse(
        'http://api.weatherstack.com/current?access_key=$apiKey&query=$location');

    final urlForecast = Uri.parse(
        'http://api.weatherstack.com/forecast?access_key=$apiKey&query=$location&forecast_days=7');

    try {
      final response = await http.get(urlCurrent);
      if (response.statusCode == 200) {
        final jsonData1 = json.decode(response.body);
        // Update the state with specific weather data
        setState(() {
          weatherData = {
            'temperature': jsonData1['current']['temperature'],
            'wind_speed': jsonData1['current']['wind_speed'],
            'wind_dir': jsonData1['current']['wind_dir'],
            'name': jsonData1['location']['name'],
            'lon': jsonData1['location']['lon'],
            'lat': jsonData1['location']['lat'],
            'country': jsonData1['location']['country'],
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

      final response2 = await http.get(urlForecast);
      if (response2.statusCode == 200) {
        final jsonData2 = json.decode(response2.body);
        // adding the dates of the returned json forecast data to a list
        final forecastDates = jsonData2['forecast'].keys.toList();

        // List to store forecast data for the first 7 dates
        List<Map<String, dynamic>> first7ForecastData = [];

        for (final date in forecastDates) {
          final forecastForDate = jsonData2['forecast'][date];
          final forecastDate = forecastForDate['date'];
          final maxTemp = forecastForDate['maxtemp'];
          final minTemp = forecastForDate['mintemp'];
          final avgTemp = forecastForDate['avgtemp'];
          final totalSnow = forecastForDate['totalsnow'];

          // Add forecast data to the list
          first7ForecastData.add({
            'date': forecastDate,
            'maxtemp': maxTemp,
            'mintemp': minTemp,
            'avgtemp': avgTemp,
            'totalsnow': totalSnow,
            // Add other forecast data here if needed
          });
        }

        // Update the state with specific weather data
        setState(() {
          forecastWeather = {
            'data': first7ForecastData,
          };
        });
      } else {
        // Handle errors
        setState(() {
          forecastWeather = {
            'error':
                'Failed to fetch weather data. Status code: ${response2.statusCode}'
          };
        });
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        weatherData = {'error': 'Exception during request: $e'};
      });
      setState(() {
        forecastWeather = {'error': '$e'};
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

  /*

     Making sure the user is only inputting the values that are in the CSV

   */

  bool isValidSuggestion(String input) {
    List<String> suggestions = getSuggestions(input);

    suggestions.any((suggestion) => suggestion.toLowerCase() == input.toLowerCase());
    return suggestions.contains(input);
  }

  void handleFavoriteSelection(String location) async {
    await fetchWeather(location);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationPage(
                weatherData: weatherData,
                forecastWeather: forecastWeather,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC0DEE5),
      key: _scaffoldKey,
      appBar: appBar(),
      drawer: Drawer(
        child: Container(
          color: Color(0xB3FFFFFF), // Apply the background color here
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(
                      0xFFC0DEE5), // Make the header transparent to inherit the container's color
                ),
                child: Text(
                  'Navigation',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favourites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favourites(
                        onLocationSelected: handleFavoriteSelection,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) =>
                        false, // Remove all routes beneath the LoginPage
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
                        // update to show suggestions as the user is typing
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
                      // Trigger weather data fetching when the user submits the search only if the data is in the CSV
                      if (isValidSuggestion(value)) {
                        fetchWeather(value);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please select a valid resort from the suggestions.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
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
                print(weatherData);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationPage(
                            weatherData: weatherData,
                            forecastWeather: forecastWeather,
                          )),
                );
              },
              child: Card(
                color: Colors.lightBlue[
                    50], // A lighter shade of blue for the background
                elevation: 4.0, // Adds a subtle shadow
                margin:
                    const EdgeInsets.all(20.0), // Adds margin around the card
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10), // Space between the icon and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Temperature: ${weatherData['temperature']}°C',
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Colors.blueGrey[900], // Darker color for text
                              fontWeight: FontWeight.bold, // Makes text bold
                            ),
                          ),
                          SizedBox(height: 8), // Space between text items
                          Text(
                            'Wind Speed: ${weatherData['wind_speed']} m/s',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[
                                  600], // Slightly lighter color for less important info
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Wind Direction: ${weatherData['wind_dir']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Image.asset(
        '/Users/benlynch/DEV/slopesense/assets/logo/mainLogoClear.png',
        height: 40, // Adjust the size of the image
      ),
      backgroundColor: Color(0xFFC0DEE5),
      leading: GestureDetector(
        onTap: () {
          // Code to open drawer
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/icons/list-svgrepo-com.svg',
          ),
          decoration: BoxDecoration(
            color: Color(0xFFC0DEE5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
