import 'package:flutter/material.dart';

ThemeData myAppTheme = ThemeData(
  // Define your theme data here
  primaryColor: Colors.blue,
  // Add more theme properties as needed

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

// ... other code

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
