import 'package:flutter/material.dart';

abstract final class Dimentions {
  // General vertical padding used to separate UI items
  static const paddingVertical = 8.0;
  static const paddingHorizontal = 16.0;

  // Vertical padding for screen edges
  static const paddingScreenVertical = paddingVertical;

  // Elevation for cards, app bars, etc.
  static const elevation = 5.0;

  static const borderRadius = 10.0;

  // Size of profile pictures
  static const profilePictureSize = 64.0;

  // Symmetric padding for screen edges (only vertical)
  static const edgeInsetsScreenVertical = EdgeInsets.symmetric(
    vertical: paddingScreenVertical,
  );
}
