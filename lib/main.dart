import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = "Bangalore";
  String temperature = "--";
  String condition = "--";
  IconData weatherIcon = Icons.wb_sunny;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getWeather("Bengaluru");
  }
  final TextEditingController cityController =
  TextEditingController();
  Future<void> getWeather(String cityName) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(
      const Duration(seconds: 2),
    );
    const apiKey = "6f8fd7c31016ebdbb2e0b551daf0cf2d";
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
    );

    final response = await http.get(url);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        city = data["name"];
        temperature = "${data["main"]["temp"]}°C";
        condition = data["weather"][0]["main"];
        isLoading = false;

        if (condition == "Clouds") {
          weatherIcon = Icons.cloud;
        } else if (condition == "Rain") {
          weatherIcon = Icons.umbrella;
        } else if (condition == "Clear") {
          weatherIcon = Icons.wb_sunny;
        } else if (condition == "Thunderstorm") {
          weatherIcon = Icons.flash_on;
        } else {
          weatherIcon = Icons.wb_cloudy;
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("City not found"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator(),
            if (isLoading)
              const SizedBox(height: 20),
        Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: cityController,
          decoration: const InputDecoration(
            hintText: "Enter City",
            border: OutlineInputBorder(),
          ),
        ),
      ),
        ElevatedButton(
        onPressed: () {
      getWeather(cityController.text);
    },
    child: const Text("Search"),
    ),
            Icon(
              weatherIcon,
              size: 100,
            ),
            const SizedBox(height: 20),

            Text(
              city,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              temperature,
              style: const TextStyle(
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              condition,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}