import 'package:flutter/material.dart';
import 'package:eatery/screens/Profile/YourMenus/menulist_widget.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct

class VerticalCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final double height;

  VerticalCard({
    required this.title,
    required this.onPressed,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenulistDetailPage(
              menulist: {
                'name': title,
                'description': 'Description for $title',
                'meals': [], // Placeholder for meals
              },
              editable: false, // Indicating this is a non-editable menulist
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
