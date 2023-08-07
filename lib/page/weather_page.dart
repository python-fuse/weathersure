import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:weathersure/utils/api_key.dart';
import 'package:weathersure/utils/title_case.dart';
import 'dart:convert';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

WeatherModel? weatherData;
final cityNameController = TextEditingController();
String searchCityName = '';

class _WeatherPageState extends State<WeatherPage> {
  bool isSearching = false; // Track whether a search is in progress

  Future<void> fetchWeatherData(String? cityName, BuildContext context) async {
    setState(() {
      isSearching = true; // Start the search
    });

    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          searchCityName = cityName ?? ''; // Update cityName only if not null
          weatherData = WeatherModel.fromJson(jsonData);
        });
      } else {
        const errorMessage =
            'Failed to fetch weather data.\nCheck the city name.';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(errorMessage),
              actions: <Widget>[
                Dismissible(
                  key: const Key('error_dialog'), // Ensure unique key
                  onDismissed: (direction) {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: TextButton(
                    child: const Text('Dismiss'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
    } finally {
      setState(() {
        isSearching = false; // End the search
      });
    }
  }

  @override
  void dispose() {
    cityNameController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sure', style: TextStyle(color: Colors.white, fontSize: 13)),
            Text('Weather'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isSearching)
                const SimpleCircularProgressBar(
                  startAngle: -80,
                  backStrokeWidth: 3,
                  progressColors: [Colors.green,Colors.lightGreen],
                  progressStrokeWidth: 5,
                  size: 20,
                  backColor: Colors.black,
                  animationDuration: 5,
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200]),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: cityNameController,
                        decoration: const InputDecoration(
                            hintText: 'Search a city',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          searchCityName = cityNameController.text;
                          fetchWeatherData(
                              searchCityName, context); // Pass context
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 70),
              
              Text(toTitleCase(weatherData?.place ?? ''),
                  style: const TextStyle(fontSize: 70)),
              Text('${weatherData?.temperature.round() ?? '0'}°C',
                  style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 20), // Adjusted spacing
              Text(toTitleCase(weatherData?.description ?? ''),
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 70), // Adjusted spacing
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Humidity',
                              style: TextStyle(fontSize: 20)),
                          Text('${weatherData?.humidity ?? '0'}%',
                              style: const TextStyle(fontSize: 18))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Feels Like',
                              style: TextStyle(fontSize: 20)),
                          Text(
                            '${weatherData?.realFeel.round() ?? '0'}\u{00B0}C',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Wind Speed',
                              style: TextStyle(fontSize: 20)),
                          Text(
                            '${weatherData?.windSpeed.round() ?? '0'} km/h',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Visibility',
                              style: TextStyle(fontSize: 20)),
                          Text(
                            '${(weatherData?.visibility ?? 0) / 1000} km',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Circular progress indicator while searching
            ],
          ),
        ),
      ),
    );
  }
}
