import 'package:flutter/material.dart';
import 'package:eatery/screens/profile/yourmenus/menulist_widget.dart'; // Ensure this path is correct

class YourMenusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MenulistWidget(),
      ),
    );
  }
}
