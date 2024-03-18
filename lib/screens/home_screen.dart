import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('This is the home screen. Add your content here.'),
      ),
      bottomNavigationBar: BottomAppBarWidget(), // Add the bottom app bar
    );
  }
}
