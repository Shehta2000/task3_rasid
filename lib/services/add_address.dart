import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placemarks[0];
  return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
}