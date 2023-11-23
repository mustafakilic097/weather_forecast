import 'package:geocode/geocode.dart';
import 'package:location/location.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._init();
  static LocationManager get instance => _instance;
  late Location _location;
  LocationManager._init() {
    _location = Location();
  }

  Future<Map<String, String>?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permission;
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission == PermissionStatus.denied) {
        return Future.error('Konum izni alınamadı!');
      }
    }
    if (permission == PermissionStatus.deniedForever) {
      return Future.error('Konum izni alınamadı! Konum izninizi almadan işleminize devam edemem.');
    }
    var position = await _location.getLocation();
    if (position.latitude == null || position.longitude == null) {
      return Future.error("Konum doğru alınamadı! Lütfen tekrar deneyin");
    }

    Address address = await GeoCode().reverseGeocoding(latitude: position.latitude!, longitude: position.longitude!);
    if (address.city != null) {
      return {"city": address.city!, "district": "Merkez"};
    }
    return null;
  }
}
