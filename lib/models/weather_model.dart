

class WeatherModel {
  final double temperature;
  final String description;
  final int humidity;
  final double realFeel;
  final double windSpeed;
  final String place;
  final int visibility;


  WeatherModel(
      {required this.temperature,
      required this.description,
      required this.humidity,
      required this.realFeel,
      required this.windSpeed,
      required this.place,
      required this.visibility      
      });

  

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'] as double,
      description: json['weather'][0]['description'] as String,
      humidity: json['main']['humidity'] as int,
      realFeel: json['main']['feels_like'] as double,
      windSpeed: json['wind']['speed'] as double,
      place: json['name'] as String,
      visibility:json['visibility'] as int
    );
  }


}
