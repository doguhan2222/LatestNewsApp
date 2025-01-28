import 'package:flutter/material.dart';

// A utility class to handle screen sizes dynamically
class ScreenSizes {
  static double width = 0.0; // Store the screen width
  static double height = 0.0; // Store the screen height

  // Method to initialize the screen size values based on the current context
  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width; // Get the screen width
    height = MediaQuery.of(context).size.height; // Get the screen height
  }
}

/*
How to use:
In any widget's build method, you can initialize the screen sizes by calling:
@override
Widget build(BuildContext context) {
  ScreenSizes.init(context); // Initialize screen size values
  return Scaffold(
    body: SizedBox(height: ScreenSizes.height * 0.01), // Example usage: dynamic height based on screen size
  );
}
*/
