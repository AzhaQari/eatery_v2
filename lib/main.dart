import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:eatery/screens/Home/home_screen.dart';
import 'package:eatery/screens/Discover/search_screen.dart';
import 'package:eatery/screens/Profile/profile_screen.dart';
import 'package:eatery/screens/Profile/signup_screen.dart';
import 'package:eatery/screens/Profile/login_screen.dart';
import 'package:eatery/theme.dart';
import 'package:algolia/algolia.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/login', // Set initial route to LoginPage
      routes: {
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/profile': (context) => ProfileScreen(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(), // Add LoginPage route
      },
    );
  }
}

final Algolia algolia = Algolia.init(
  applicationId: '9EHWYVNJY9',
  apiKey: 'e1baf96f6dce70195bbe680d1ac8047e',
);
