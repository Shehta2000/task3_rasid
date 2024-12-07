import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _address = 'Fetching address...';

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
  }

  Future<void> _checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServicesDialog();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await getCurrentLocation();
      String address = await getAddressFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _address = address;
      });
    } catch (e) {
      setState(() {
        _address = 'Error: $e';
      });
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  void getLocationFromGoogleMapsLink(String url) {
    final uri = Uri.parse(url);
    final lat = double.parse(uri.queryParameters['q']!.split(',')[0]);
    final lng = double.parse(uri.queryParameters['q']!.split(',')[1]);
    print('Latitude: $lat, Longitude: $lng');
  }

  void getLocationFromCoordinates(double latitude, double longitude) {
    print('Latitude: $latitude, Longitude: $longitude');
  }

  void _showLocationServicesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to continue.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location and Address')),
      body: Center(
        child: Text(_address),
      ),
    );
  }
}