import 'package:flutter/material.dart';
import 'package:task3/views/location_screen.dart';

void main() {
  runApp(const GetLocation());
}

class GetLocation extends StatelessWidget {
  const GetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationScreen(),
    );
  }
}