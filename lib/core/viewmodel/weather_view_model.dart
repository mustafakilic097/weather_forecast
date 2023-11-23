// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/utils.dart';
import 'package:weather_forecast/core/init/network/network_manager.dart';

import '../model/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  List<Weather> currentWeatherData = List.generate(7, (index) => Weather.blank());

  Future<List<Weather>> getWeatherData() async {
    final data = await NetworkManager.instance.dioGet();
    List<Weather> result = List.generate(7, (index) => Weather.blank());
    List.generate(7, (i) {
      try {
        result[i] = Weather.fromJson(data![i]);
      } catch (e) {
        Get.printInfo(info: e.toString());
      }
    });
    currentWeatherData = result;
    notifyListeners();
    return result;
  }
}

final weatherViewModel = ChangeNotifierProvider((ref) => WeatherViewModel());
