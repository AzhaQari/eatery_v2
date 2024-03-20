import 'package:flutter/material.dart';
import 'package:eatery/screens/home_screen.dart';
import 'package:eatery/screens/search_screen.dart';
import 'package:eatery/screens/profile_screen.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/theme.dart';
import 'package:algolia/algolia.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: myAppTheme, // Use the theme defined in theme.dart
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

final Algolia algolia = Algolia.init(
  applicationId: '9EHWYVNJY9',
  apiKey: 'e1baf96f6dce70195bbe680d1ac8047e',
);