import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/core/constants/app/app_constants.dart';
import 'package:weather_forecast/core/init/cache/locale_manager.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._init();
  static NetworkManager get instance => _instance;
  late Dio _dio;
  NetworkManager._init() {
    final baseOptions = BaseOptions(
        baseUrl: AppConstants.BASE_API_URL,
        headers: {"authorization": AppConstants.AUTHORIZATION_KEY, "content-type": "application/json"});
    _dio = Dio(baseOptions);
    // MARK add interceptor
  }

  Future<List<Map<String, dynamic>>?> dioGet() async {
    String dataLang = Get.locale?.languageCode ?? "tr";
    String dataCity = LocaleManager.instance.getStringValue("cities")?.split(",")[0] ?? AppConstants.DEFAULT_CITY;
    final response = await _dio.get("?data.lang=$dataLang&data.city=$dataCity");
    if (response.statusCode == HttpStatus.ok) {
      final List list = response.data["result"];
      final List<Map<String, dynamic>> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(list[i] as Map<String, dynamic>);
      }
      return result;
    }
    response.printError(info: "ERROR: ${response.statusMessage.toString()}");
    return null;
  }
}
