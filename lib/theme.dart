import 'package:flutter/material.dart';

// Define your custom color list for menu items
const List<Color> menuItemColors = [
  Color(0xFFF94144),
  Color(0xFFF3722C),
  Color(0xFFF8961E),
  Color(0xFFF9844A),
  Color(0xFF90BE6D),
  Color(0xFF43AA8B),
  Color(0xFF4D908E),
  Color(0xFF577590),
  Color(0xFF277DA1),
];

// Define your dark color
final Color lightColor = Color(0xFFC0C0C0);
final Color darkColor = Color(0xFF1E1E1E);

// Define your light theme data
final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.blue, // Example primary color for light theme
  // Define other light theme properties here
  scaffoldBackgroundColor: lightColor,
  backgroundColor: lightColor,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColor,
  ),
  bottomAppBarTheme: BottomAppBarTheme(
    color: lightColor,
  ),
  // Disable page transition animations
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.linux: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.macOS: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.windows: NoTransitionPageTransitionsBuilder(),
    },
  ),
);

// Define your dark theme data
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Define other dark theme properties here
  scaffoldBackgroundColor: darkColor,
  backgroundColor: darkColor,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColor,
  ),
  bottomAppBarTheme: BottomAppBarTheme(
    color: darkColor,
  ),
  // Disable page transition animations
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.linux: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.macOS: NoTransitionPageTransitionsBuilder(),
      TargetPlatform.windows: NoTransitionPageTransitionsBuilder(),
    },
  ),
);

class NoTransitionPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }
}