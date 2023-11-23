import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/core/init/cache/locale_manager.dart';
import 'package:weather_forecast/core/model/location_model.dart';

class LocationViewModel extends ChangeNotifier {
  List<Location> locations = [];

  void getLocations() {
    var instance = LocaleManager.instance;
    String cities = instance.getStringValue("cities") ?? "";
    List<Location> result = [];
    if (cities == "") {
      instance.resetValue("cities");
      return;
    } else {
      if (cities.split(",")[0] != "") {
        List.generate(cities.split(",").length,
            (index) => result.add(Location(cityName: cities.split(",")[index], districtName: "Merkez")));
      }
    }

    locations = result;
    notifyListeners();
  }

  Future<void> addLocation(String city) async {
    var instance = LocaleManager.instance;
    String cities = instance.getStringValue("cities") ?? "";
    locations.clear();
    if (cities == "") {
      instance.setStringValue("cities", city);
      locations.add(Location(cityName: city, districtName: "Merkez"));
    } else {
      if (cities.contains(city)) {
        throw Exception("Bu konum zaten var!!");
      }
      cities += ",$city";
      instance.setStringValue("cities", cities);
      locations.addAll(cities.split(",").map((e) => Location(cityName: e, districtName: "Merkez")).toList());
    }
    notifyListeners();
  }

  Future<void> removeLocation(String city) async {
    var instance = LocaleManager.instance;
    String cities = instance.getStringValue("cities") ?? "";
    if (cities == "") {
      instance.resetValue("cities");
      return;
    }
    String newCities = "";
    cities.split(",").map((e) {
      if (city != e) {
        if (newCities == "") {
          newCities = e;
        } else {
          newCities = "$newCities,$e";
        }
      }
    });
    instance.setStringValue("cities", newCities);
    locations.clear();
    if (newCities.split(",")[0] != "") {
      locations.addAll(newCities.split(",").map((e) => Location(cityName: e, districtName: "Merkez")));
    }
    notifyListeners();
  }

  Future<bool?> resetLocations() async {
    var instance = LocaleManager.instance;
    return await instance.resetValue("cities");
  }
}

final locationViewModel = ChangeNotifierProvider((ref) => LocationViewModel());
